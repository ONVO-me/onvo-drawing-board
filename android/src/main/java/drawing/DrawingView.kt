package com.ttv.drawingboard.drawing

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Canvas
import android.util.AttributeSet
import android.view.MotionEvent
import android.view.View
import com.ttv.drawingboard.drawing.renderer.RasmRendererFactory
import com.ttv.drawingboard.drawing.renderer.Renderer
import com.ttv.drawingboard.drawing.state.RState
import com.ttv.drawingboard.drawing.touch.handler.RasmViewEventHandlerFactory
import com.ttv.drawingboard.drawing.touch.handler.MotionEventHandler

class DrawingView(
    context: Context,
    attrs: AttributeSet?,
    defStyleAttr: Int,
): View(context, attrs, defStyleAttr) {

    constructor(context: Context): this(context, null)

    constructor(context: Context, attrs: AttributeSet? = null): this(context, attrs, 0)

    val boardContext = BoardContext()

    init {
        boardContext.state.addOnStateChangedListener(::onRasmStateChanged)
        boardContext.brushToolStatus.addOnChangeListener {
            updateRenderer()
        }
    }

    private val eventHandlerFactory = RasmViewEventHandlerFactory()
    private var touchHandler: MotionEventHandler? = null
    private var rendererFactory = RasmRendererFactory()
    private var render: Renderer? = null

    override fun onSizeChanged(w: Int, h: Int, oldw: Int, oldh: Int) {
        super.onSizeChanged(w, h, oldw, oldh)
        if (boardContext.hasRasm || w == 0 || h == 0) {
            return
        }
        boardContext.setRasm(w, h)
        updateRenderer()
        resetTransformation()
    }

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        render?.render(canvas)
    }

    @SuppressLint("ClickableViewAccessibility")
    override fun onTouchEvent(event: MotionEvent): Boolean {
        when (event.actionMasked) {
            MotionEvent.ACTION_DOWN -> {
                touchHandler = eventHandlerFactory.create(boardContext)
                touchHandler!!.handleFirstTouch(event)
            }
            MotionEvent.ACTION_UP, MotionEvent.ACTION_CANCEL -> {
                if (event.actionMasked == MotionEvent.ACTION_UP) {
                    touchHandler!!.handleLastTouch(event)
                } else {
                    touchHandler!!.cancel()
                }
                touchHandler = null
            }
            else -> {
                touchHandler!!.handleTouch(event)
            }
        }
        invalidate()
        return true
    }

    fun resetTransformation() {
        boardContext.resetTransformation(width, height)
        invalidate()
    }

    private fun updateRenderer() {
        render = rendererFactory.createOnscreenRenderer(boardContext)
        invalidate()
    }

    private fun onRasmStateChanged(rState: RState) {
        render = rendererFactory.createOnscreenRenderer(boardContext)
        invalidate()
    }

}
