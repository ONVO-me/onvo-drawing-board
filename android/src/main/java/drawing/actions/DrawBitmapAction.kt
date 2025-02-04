package com.raed.rasmview.actions

import android.graphics.*
import com.ttv.drawingboard.drawing.BoardContext
import com.ttv.drawingboard.drawing.actions.Action

private var SRC_PAINT = Paint().apply {
    xfermode = PorterDuffXfermode(PorterDuff.Mode.SRC)
}

internal class DrawBitmapAction(
    private val srcBitmap: Bitmap,
    private val srcRect: Rect,
    private val dstRect: Rect,
): Action {

    override val size: Int
        get() = srcBitmap.byteCount

    override fun perform(context: BoardContext) {
        Canvas(context.brushToolBitmaps.layerBitmap)
            .drawBitmap(srcBitmap, srcRect, dstRect, SRC_PAINT)
    }

    override fun getOppositeAction(context: BoardContext): Action {
        val srcBitmap = Bitmap.createBitmap(
            context.brushToolBitmaps.layerBitmap,
            dstRect.left, dstRect.top,
            dstRect.width(), dstRect.height(),
        )
        return DrawBitmapAction(
            srcBitmap,
            Rect(0, 0, srcBitmap.width, srcBitmap.height),
            dstRect,
        )
    }

}