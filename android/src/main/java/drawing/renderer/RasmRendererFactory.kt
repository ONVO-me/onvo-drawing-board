package com.ttv.drawingboard.drawing.renderer

import android.graphics.Rect
import com.ttv.drawingboard.drawing.BoardContext

internal class RasmRendererFactory {

    fun createOnscreenRenderer(boardContext: BoardContext): Renderer? {
        if (!boardContext.hasRasm) {
            return null
        }
        return if (boardContext.brushToolStatus.active){
            createBrushToolResultRenderer(boardContext)
        } else {
            createLayerRenderer(boardContext)
        }
    }

    fun createOffscreenRenderer(boardContext: BoardContext): Renderer {
        return ListRenderer(
            RectRenderer(
                Rect(0, 0, boardContext.rWidth, boardContext.rHeight),
                boardContext.backgroundColor,
            ),
            BitmapRenderer(
                boardContext.brushToolBitmaps.layerBitmap,
            ),
        )
    }

    private fun createBrushToolResultRenderer(boardContext: BoardContext): Renderer {
        return TransformedRenderer(
            boardContext.transformation,
            ListRenderer(
                RectRenderer(
                    Rect(0, 0, boardContext.rWidth, boardContext.rHeight),
                    boardContext.backgroundColor,
                ),
                BitmapRenderer(
                    boardContext.brushToolBitmaps.resultBitmap,
                ),
            ),
        )
    }

    private fun createLayerRenderer(boardContext: BoardContext): Renderer {
        return TransformedRenderer(
            boardContext.transformation,
            ListRenderer(
                RectRenderer(
                    Rect(0, 0, boardContext.rWidth, boardContext.rHeight),
                    boardContext.backgroundColor,
                ),
                BitmapRenderer(
                    boardContext.brushToolBitmaps.layerBitmap,
                ),
            ),
        )
    }

}
