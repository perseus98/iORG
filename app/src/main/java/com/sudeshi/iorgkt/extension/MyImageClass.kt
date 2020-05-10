package com.sudeshi.iorgkt.extension

import android.content.Context
import android.graphics.Canvas
import android.util.AttributeSet
import android.view.MotionEvent
import android.view.ScaleGestureDetector
import android.view.ScaleGestureDetector.SimpleOnScaleGestureListener


class MyImageView(
    context: Context?,
    attrs: AttributeSet?,
    defStyle: Int
) :
    androidx.appcompat.widget.AppCompatImageView(context, attrs, defStyle) {
    private var mPosX = 0f
    private var mPosY = 0f
    private var mLastTouchX = 0f
    private var mLastTouchY = 0f
    private var mLastGestureX = 0f
    private var mLastGestureY = 0f
    private var mActivePointerId = INVALID_POINTER_ID
    private var mScaleDetector: ScaleGestureDetector
    private var mScaleFactor = 1f

    constructor(
        context: Context?,
        attrs: AttributeSet?
    ) : this(context, attrs, 0) {
        mScaleDetector = ScaleGestureDetector(getContext(), ScaleListener())
    }

    override fun onTouchEvent(ev: MotionEvent): Boolean {
        // Let the ScaleGestureDetector inspect all events.
        mScaleDetector.onTouchEvent(ev)
        val action = ev.action
        when (action and MotionEvent.ACTION_MASK) {
            MotionEvent.ACTION_DOWN -> {
                if (!mScaleDetector.isInProgress) {
                    val x = ev.x
                    val y = ev.y
                    mLastTouchX = x
                    mLastTouchY = y
                    mActivePointerId = ev.getPointerId(0)
                }
            }
            MotionEvent.ACTION_POINTER_1_DOWN -> {
                if (mScaleDetector.isInProgress) {
                    val gx = mScaleDetector.focusX
                    val gy = mScaleDetector.focusY
                    mLastGestureX = gx
                    mLastGestureY = gy
                }
            }
            MotionEvent.ACTION_MOVE -> {


                // Only move if the ScaleGestureDetector isn't processing a gesture.
                if (!mScaleDetector.isInProgress) {
                    val pointerIndex = ev.findPointerIndex(mActivePointerId)
                    val x = ev.getX(pointerIndex)
                    val y = ev.getY(pointerIndex)
                    val dx = x - mLastTouchX
                    val dy = y - mLastTouchY
                    mPosX += dx
                    mPosY += dy
                    invalidate()
                    mLastTouchX = x
                    mLastTouchY = y
                } else {
                    val gx = mScaleDetector.focusX
                    val gy = mScaleDetector.focusY
                    val gdx = gx - mLastGestureX
                    val gdy = gy - mLastGestureY
                    mPosX += gdx
                    mPosY += gdy
                    invalidate()
                    mLastGestureX = gx
                    mLastGestureY = gy
                }
            }
            MotionEvent.ACTION_UP -> {
                mActivePointerId = INVALID_POINTER_ID
            }
            MotionEvent.ACTION_CANCEL -> {
                mActivePointerId = INVALID_POINTER_ID
            }
            MotionEvent.ACTION_POINTER_UP -> {
                val pointerIndex = (ev.action and MotionEvent.ACTION_POINTER_INDEX_MASK
                        shr MotionEvent.ACTION_POINTER_INDEX_SHIFT)
                val pointerId = ev.getPointerId(pointerIndex)
                if (pointerId == mActivePointerId) {
                    // This was our active pointer going up. Choose a new
                    // active pointer and adjust accordingly.
                    val newPointerIndex = if (pointerIndex == 0) 1 else 0
                    mLastTouchX = ev.getX(newPointerIndex)
                    mLastTouchY = ev.getY(newPointerIndex)
                    mActivePointerId = ev.getPointerId(newPointerIndex)
                } else {
                    val tempPointerIndex = ev.findPointerIndex(mActivePointerId)
                    mLastTouchX = ev.getX(tempPointerIndex)
                    mLastTouchY = ev.getY(tempPointerIndex)
                }
            }
        }
        return true
    }

    public override fun onDraw(canvas: Canvas) {
        canvas.save()
        canvas.translate(mPosX, mPosY)
        if (mScaleDetector.isInProgress) {
            canvas.scale(
                mScaleFactor,
                mScaleFactor,
                mScaleDetector.focusX,
                mScaleDetector.focusY
            )
        } else {
            canvas.scale(mScaleFactor, mScaleFactor, mLastGestureX, mLastGestureY)
        }
        super.onDraw(canvas)
        canvas.restore()
    }

    private inner class ScaleListener : SimpleOnScaleGestureListener() {
        override fun onScale(detector: ScaleGestureDetector): Boolean {
            mScaleFactor *= detector.scaleFactor

            // Don't let the object get too small or too large.
            mScaleFactor = 0.1f.coerceAtLeast(mScaleFactor.coerceAtMost(10.0f))
            invalidate()
            return true
        }
    }

    companion object {
        private const val INVALID_POINTER_ID = -1
    }

    init {
        mScaleDetector = ScaleGestureDetector(context, ScaleListener())
    }
}