package com.raed.rasmview.actions

import android.graphics.Bitmap
import android.graphics.Rect
import com.ttv.drawingboard.drawing.BoardContext
import com.ttv.drawingboard.drawing.actions.Action

internal class ClearAction: Action {

    override fun perform(context: BoardContext) {
        context.brushToolBitmaps.layerBitmap.eraseColor(0)
    }

    override fun getOppositeAction(context: BoardContext): Action {
        val drawingCopy = context.brushToolBitmaps.layerBitmap.copy(Bitmap.Config.ARGB_8888, false)
        val rect = Rect(0, 0, drawingCopy.width, drawingCopy.height)
        return DrawBitmapAction(drawingCopy, rect, rect)
    }

}