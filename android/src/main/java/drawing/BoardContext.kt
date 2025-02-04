package com.ttv.drawingboard.drawing

import android.graphics.Bitmap
import android.graphics.Bitmap.Config.ARGB_8888
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Matrix
import android.graphics.RectF
import com.raed.rasmview.actions.ChangeBackgroundAction
import com.raed.rasmview.actions.ClearAction
import com.ttv.drawingboard.drawing.brushtool.BrushToolBitmaps
import com.ttv.drawingboard.drawing.brushtool.BrushToolStatus
import com.ttv.drawingboard.drawing.brushtool.model.BrushConfig
import com.ttv.drawingboard.drawing.renderer.RasmRendererFactory
import com.ttv.drawingboard.drawing.state.RState

class BoardContext internal constructor() {

    private var nullableBrushToolBitmaps: BrushToolBitmaps? = null
        set(value) {
            require(value != null)
            field = value
        }
    internal val brushToolBitmaps get() = nullableBrushToolBitmaps!!
    var brushToolStatus = BrushToolStatus()
    val hasRasm get() = nullableBrushToolBitmaps != null
    val rWidth get() = brushToolBitmaps.layerBitmap.width
    val rHeight get() = brushToolBitmaps.layerBitmap.height
    val state = RState(this)
    val transformation = Matrix()
    var brushConfig = BrushConfig()
    var brushColor = 0xff2187bb.toInt()
    var rotationEnabled = false
    internal var backgroundColor = Color.TRANSPARENT

    fun setRasm(
        drawingWidth: Int,
        drawingHeight: Int,
    ) = setRasm(Bitmap.createBitmap(drawingWidth, drawingHeight, ARGB_8888))

    fun setRasm(rasm: Bitmap) {
        nullableBrushToolBitmaps = BrushToolBitmaps.createFromDrawing(rasm)
        state.reset()
    }

    fun exportRasm(): Bitmap {
        val rasm = Bitmap.createBitmap(rWidth, rHeight, ARGB_8888)
        val rasmRenderer = RasmRendererFactory().createOffscreenRenderer(this)
        rasmRenderer.render(Canvas(rasm))
        return rasm
    }

    fun clear() {
        state.update(
            ClearAction(),
        )
    }

    fun setBackgroundColor(color: Int) {
        state.update(
            ChangeBackgroundAction(color),
        )
    }

    internal fun resetTransformation(containerWidth: Int, containerHeight: Int) {
        transformation.setRectToRect(
            RectF(0F, 0F, rWidth.toFloat(), rHeight.toFloat()),
            RectF(0f, 0f, containerWidth.toFloat(), containerHeight.toFloat()),
            Matrix.ScaleToFit.CENTER,
        )
    }

}
