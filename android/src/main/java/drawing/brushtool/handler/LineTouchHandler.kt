package com.ttv.drawingboard.drawing.brushtool.handler

import com.ttv.drawingboard.drawing.brushtool.model.TouchEvent
import kotlin.math.sqrt

internal class LineTouchHandler(
    private val step: Float,
    private val nextHandler: TouchHandler,
) : TouchHandler {

    private var startX: Float = 0f
    private var startY: Float = 0f

    override fun handleFirstTouch(event: TouchEvent) {
        startX = event.x
        startY = event.y
        nextHandler.handleFirstTouch(event)
    }

    override fun handleTouch(event: TouchEvent) {
        val currentX = event.x
        val currentY = event.y
        generateLinePoints(startX, startY, currentX, currentY, step).forEach { point ->
            nextHandler.handleTouch(TouchEvent(point.x, point.y, event.p))
        }
    }

    override fun handleLastTouch(event: TouchEvent) {
        handleTouch(event) // Process the final position
        nextHandler.handleLastTouch(event)
    }

    private fun generateLinePoints(x1: Float, y1: Float, x2: Float, y2: Float, step: Float): List<PointF> {
        val points = mutableListOf<PointF>()
        val dx = x2 - x1
        val dy = y2 - y1
        val distance = sqrt(dx * dx + dy * dy)
        if (distance == 0f) return listOf(PointF(x1, y1))

        val steps = (distance / step).toInt()
        val stepX = dx / steps
        val stepY = dy / steps

        for (i in 0..steps) {
            points.add(PointF(x1 + stepX * i, y1 + stepY * i))
        }
        return points
    }

    private data class PointF(val x: Float, val y: Float)
}