package com.ttv.drawingboard.drawing.brushtool

import android.graphics.Rect
import com.ttv.drawingboard.drawing.BoardContext
import com.ttv.drawingboard.drawing.brushtool.model.TouchEvent
import com.ttv.drawingboard.drawing.brushtool.handler.CubicInterpolationTouchHandler
import com.ttv.drawingboard.drawing.brushtool.handler.LineTouchHandler
import com.ttv.drawingboard.drawing.brushtool.handler.LinearInterpolationTouchHandler
import com.ttv.drawingboard.drawing.brushtool.handler.TouchHandler
import com.ttv.drawingboard.drawing.brushtool.renderer.StampRenderer

class BrushTool internal constructor(
    private val boardContext: BoardContext, // Add context parameter

    private val stampRenderer: StampRenderer,
    private val resultBitmapUpdater: ResultBitmapUpdater,
    private val step: Float,
) {

    private val boundaryRect = Rect()
    private var touchHandler = createTouchHandler()
    val strokeBoundary = Rect()

    private val lastEvent = TouchEvent()

    fun startDrawing(event: TouchEvent) {
        strokeBoundary.setEmpty()
        touchHandler.handleFirstTouch(event)
        resultBitmapUpdater.update()
        lastEvent.set(event)
    }

    fun continueDrawing(event: TouchEvent) {
        if (boardContext.brushConfig.isStraightLineMode) {
            boardContext.brushToolBitmaps.strokeBitmap.eraseColor(0)
            boundaryRect.set(0, 0, boardContext.rWidth, boardContext.rHeight)
        } else {
            boundaryRect.setEmpty()
        }

        touchHandler.handleTouch(event)
        boundaryRect.inset(-5, -5)
        resultBitmapUpdater.update(boundaryRect)
        lastEvent.set(event)
    }

    fun endDrawing(event: TouchEvent) {
        touchHandler.handleLastTouch(event)
        resultBitmapUpdater.update()
    }

    fun cancel() {
        touchHandler.handleLastTouch(lastEvent)
    }

    private fun createTouchHandler(): TouchHandler {
        return if (boardContext.brushConfig.isStraightLineMode) {
            LineTouchHandler(
                step,
                createRenderingTouchHandler()
            )
        } else {
            CubicInterpolationTouchHandler(
                step,
                LinearInterpolationTouchHandler(
                    step,
                    createRenderingTouchHandler()
                )
            )
        }
    }

    private fun createRenderingTouchHandler() = object : TouchHandler {

        private val stampBoundary = Rect()

        override fun handleFirstTouch(event: TouchEvent) { }

        override fun handleTouch(event: TouchEvent) {
            stampRenderer.render(event, stampBoundary)
            boundaryRect.union(stampBoundary)
            strokeBoundary.union(stampBoundary)
        }

        override fun handleLastTouch(event: TouchEvent) {
            stampRenderer.render(event, stampBoundary)
            strokeBoundary.union(stampBoundary)
        }

    }

}
