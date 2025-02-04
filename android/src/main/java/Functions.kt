package com.ttv.drawingboard

import android.content.Context
import android.graphics.Bitmap
import android.provider.MediaStore
import com.ttv.drawingboard.drawing.BoardContext
import com.ttv.drawingboard.drawing.DrawingView
import com.ttv.drawingboard.drawing.brushtool.data.Brush
import com.ttv.drawingboard.drawing.brushtool.data.BrushesRepository
import java.io.File
import java.io.FileOutputStream
import java.io.OutputStream

 fun undoAction(boardContext: BoardContext) {
    boardContext.state.undo()

}

 fun redoAction(boardContext: BoardContext) {
    boardContext.state.redo()

}

fun saveBitmap(boardContext: BoardContext , context: Context){

    val bitmap =  boardContext.exportRasm()


    // Assume block needs to be inside a Try/Catch block.
    val path = context.getExternalFilesDir(null).toString()
    var fOut: OutputStream? = null
    val file = File(
        path,
        "FitnessGirl${bitmap}.jpg"
    ) // the File to save , append increasing numeric counter to prevent files from getting overwritten.
    fOut = FileOutputStream(file)

    val pictureBitmap: Bitmap = bitmap // obtaining the Bitmap
    pictureBitmap.compress(
        Bitmap.CompressFormat.JPEG,
        85,
        fOut
    ) // saving the Bitmap to a file compressed as a JPEG with 85% compression rate
    fOut.flush() // Not really required
    fOut.close() // do not forget to close the stream

    MediaStore.Images.Media.insertImage(
        context.contentResolver,
        file.absolutePath,
        file.name,
        file.name
    )
}

fun saveSelectedColor(context: Context, selectedColor: Int) {
    // Name of the shared preferences file and key for the color list
    val prefs = context.getSharedPreferences("my_preferences", Context.MODE_PRIVATE)
    val key = "colors"

    // Retrieve the stored colors (if any) as a comma separated string.
    // If nothing is stored, default to an empty list.
    val colorsString = prefs.getString(key, "") ?: ""
    val colorsList = if (colorsString.isNotEmpty()) {
        colorsString.split(",")
            .mapNotNull { it.toIntOrNull() }
            .toMutableList()
    } else {
        mutableListOf<Int>()
    }

    // Insert the new color at the beginning
    colorsList.add(0, selectedColor)

    // Ensure the list only has a maximum of 6 items: remove last element if needed
    if (colorsList.size > 6) {
        colorsList.removeAt(colorsList.lastIndex)
    }

    // Save the updated list back to SharedPreferences as a comma separated string.
    val newColorsString = colorsList.joinToString(separator = ",")
    prefs.edit().putString(key, newColorsString).apply()
}


fun getSavedColors(context: Context): List<Int> {
    val prefs = context.getSharedPreferences("my_preferences", Context.MODE_PRIVATE)
    val key = "colors"

    // Retrieve the stored colors as a comma-separated string.
    val colorsString = prefs.getString(key, "") ?: ""
    if (colorsString.isEmpty()) return emptyList()

    // Convert the string back to a list of Int values.
    return colorsString.split(",")
        .mapNotNull { it.toIntOrNull() }
}

fun brushConfigSize(sizeValue:Float,boardContext: BoardContext){
    boardContext.brushConfig.size = sizeValue

}
fun brushConfigOpacity(opacityValue:Float,boardContext: BoardContext){
    boardContext.brushConfig.size = opacityValue

}

 fun brushConfigPen(boardContext: BoardContext, brushesRepository: BrushesRepository) {
    boardContext.brushConfig = brushesRepository.get(Brush.Pen)

}
 fun brushConfigPencil(boardContext: BoardContext, brushesRepository: BrushesRepository) {
    boardContext.brushConfig = brushesRepository.get(Brush.Pencil)
}
 fun brushConfigAirBrush(boardContext: BoardContext, brushesRepository: BrushesRepository) {
    boardContext.brushConfig = brushesRepository.get(Brush.AirBrush)

}
 fun brushConfigMarker(boardContext: BoardContext, brushesRepository: BrushesRepository) {
    boardContext.brushConfig = brushesRepository.get(Brush.Marker)

}
 fun brushConfigHardEraser(boardContext: BoardContext, brushesRepository: BrushesRepository) {
    boardContext.brushConfig = brushesRepository.get(Brush.HardEraser)

}
 fun brushConfigSoftEraser(boardContext: BoardContext, brushesRepository: BrushesRepository) {
    boardContext.brushConfig = brushesRepository.get(Brush.SoftEraser)

}
 fun enableDisableRotation(drawingView: DrawingView) {
    drawingView.boardContext.rotationEnabled = !drawingView.boardContext.rotationEnabled

}
 fun enableDisableRuler(drawingView: DrawingView) {
    drawingView.boardContext.brushConfig.isStraightLineMode = !drawingView.boardContext.brushConfig.isStraightLineMode

}