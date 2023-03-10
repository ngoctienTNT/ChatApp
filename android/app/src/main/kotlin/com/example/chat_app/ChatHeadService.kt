package com.example.chat_app

import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.os.Build
import android.os.IBinder
import android.view.*
import android.view.View.OnTouchListener
import android.view.View.SYSTEM_UI_LAYOUT_FLAGS
import android.widget.ImageView
import android.widget.RelativeLayout

class ChatHeadService : Service() {
    private var mWindowManager: WindowManager? = null
    private var mFloatingView: View? = null
    private lateinit var imageClose: ImageView;

//    fun FloatingViewService() {}

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onCreate() {
        super.onCreate()
        //Inflate the floating view layout we created
        mFloatingView = LayoutInflater.from(this).inflate(R.layout.layout_chat_head, null)

        //Add the view to the window.
        val params = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT
            )
        } else {
            TODO("VERSION.SDK_INT < O")
        }

        //Specify the view position
        params.gravity = Gravity.TOP or Gravity.START //Initially view will be added to top-left corner
        params.x = 0
        params.y = 100

        val imageParams = WindowManager.LayoutParams(140,140,
            SYSTEM_UI_LAYOUT_FLAGS,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
            PixelFormat.TRANSLUCENT)

        imageClose = ImageView(this)
        imageClose.setImageResource(R.drawable.ic_close)
        imageClose.visibility = View.INVISIBLE
        mWindowManager?.addView(imageClose, imageParams)

        //Add the view to the window
        mWindowManager = getSystemService(WINDOW_SERVICE) as WindowManager
        mWindowManager!!.addView(mFloatingView, params)

        //The root element of the collapsed view layout
        val collapsedView: View = mFloatingView!!.findViewById(R.id.collapse_view)
        //The root element of the expanded view layout
        val expandedView: View = mFloatingView!!.findViewById(R.id.expanded_container)

        val window = getSystemService(Context.WINDOW_SERVICE) as WindowManager
        val display = window.defaultDisplay
        val width = display.width
        val height = display.height
        val avatar = mFloatingView!!.findViewById(R.id.avatar) as ImageView

        avatar.setOnClickListener()
        {
            params.width = WindowManager.LayoutParams.WRAP_CONTENT
            mWindowManager?.updateViewLayout(mFloatingView, params)
            collapsedView.visibility = View.VISIBLE
            expandedView.visibility = View.GONE
        }

        val root = mFloatingView!!.findViewById(R.id.root_container) as RelativeLayout

        //Drag and move floating view using user's touch action.
        root.setOnTouchListener(object : OnTouchListener {
                private var initialX = 0
                private var initialY = 0
                private var initialTouchX = 0f
                private var initialTouchY = 0f
                private var lastEvent:Int = -1;

                override fun onTouch(v: View?, event: MotionEvent): Boolean {
                    when (event.action) {
                        MotionEvent.ACTION_DOWN -> {

                            //remember the initial position.
                            initialX = params.x
                            initialY = params.y

                            //get the touch location
                            initialTouchX = event.rawX
                            initialTouchY = event.rawY
                            lastEvent = MotionEvent.ACTION_DOWN
                            return true
                        }
                        MotionEvent.ACTION_UP -> {
                            val Xdiff = (event.rawX - initialTouchX).toInt()
                            val Ydiff = (event.rawY - initialTouchY).toInt()


                            //The check for Xdiff <10 && YDiff< 10 because sometime elements moves a little while clicking.
                            //So that is click event.
                            if (Xdiff < 10 && Ydiff < 10) {
                                if (isViewCollapsed() && lastEvent == MotionEvent.ACTION_DOWN) {
                                    //When user clicks on the image view of the collapsed layout,
                                    //visibility of the collapsed layout will be changed to "View.GONE"
                                    //and expanded view will become visible.

                                    params.width = WindowManager.LayoutParams.MATCH_PARENT
                                    mWindowManager?.updateViewLayout(mFloatingView, params)
                                    collapsedView.visibility = View.GONE
                                    expandedView.visibility = View.VISIBLE
                                }
                            }

                            if (lastEvent == MotionEvent.ACTION_MOVE)
                            {
                                if (params.x<width/2) params.x=0
                                else params.x=width
                                mWindowManager!!.updateViewLayout(mFloatingView, params)

                                if (params.y>height*0.6)
                                {
                                    stopSelf()
                                }
                            }

                            return true
                        }
                        MotionEvent.ACTION_MOVE -> {
                            //Calculate the X and Y coordinates of the view.
                            params.x = initialX + (event.rawX - initialTouchX).toInt()
                            params.y = initialY + (event.rawY - initialTouchY).toInt()

                            //Update the layout with new X & Y coordinate
                            mWindowManager!!.updateViewLayout(mFloatingView, params)
                            if (params.y>height*0.6)
                            {
                                imageClose.visibility = View.GONE
                            }
                            lastEvent = MotionEvent.ACTION_MOVE
                            return true
                        }
                    }
                    return false
                }
            })
    }


    /**
     * Detect if the floating view is collapsed or expanded.
     *
     * @return true if the floating view is collapsed.
     */
    private fun isViewCollapsed(): Boolean {
        val view = mFloatingView!!.findViewById(R.id.collapse_view) as RelativeLayout
        return mFloatingView == null || view.visibility == View.VISIBLE
    }


    override fun onDestroy() {
        super.onDestroy()
        if (mFloatingView != null) mWindowManager!!.removeView(mFloatingView)
    }
}