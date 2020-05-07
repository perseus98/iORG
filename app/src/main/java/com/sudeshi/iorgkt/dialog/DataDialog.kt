package com.sudeshi.iorgkt.dialog

import android.app.Dialog
import android.content.res.TypedArray
import android.graphics.BitmapFactory
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.Window
import androidx.fragment.app.DialogFragment
import com.sudeshi.iorgkt.R
import com.sudeshi.iorgkt.db.model.Data
import kotlinx.android.synthetic.main.layout_data_view.*
import java.time.format.DateTimeFormatter
import java.time.format.FormatStyle


class DataDialog(tempData : Data) : DialogFragment() {
    private val tmpData = tempData
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        // Inflate the layout to use as dialog or embedded fragment
        return inflater.inflate(R.layout.layout_data_view, container, false)
    }
    /** The system calls this only when creating the layout in a dialog. */
    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        // The only reason you might override this method when using onCreateView() is
        // to modify any dialog characteristics. For example, the dialog includes a
        // title by default, but your custom layout might not need it. So here you can
        // remove the dialog title, but you must call the superclass to get the Dialog.
        val dialog = super.onCreateDialog(savedInstanceState)
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE)

        return dialog
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        toolbarDialog.setNavigationOnClickListener { dismiss() }
        toolbarDialog.title = "Selected Data Entry"
        toolbarDialog.inflateMenu(R.menu.toolbar_dialog)
        toolbarDialog.setOnMenuItemClickListener {
            dismiss()
            true
        }
        initContent()
    }

    override fun onStart() {
        super.onStart()
        val dialog = dialog
        if (dialog != null) {
            val width = ViewGroup.LayoutParams.MATCH_PARENT
            val height = ViewGroup.LayoutParams.MATCH_PARENT
            dialog.window!!.setLayout(width, height)
        }
    }
    private fun initContent(){

        layout_data_vw_img.setImageBitmap(BitmapFactory.decodeFile(tmpData.pic_path))
        layout_data_vw_name.text = tmpData.name
        layout_data_vw_date.text = tmpData.date.format(
            DateTimeFormatter.ofLocalizedDateTime(
                FormatStyle.MEDIUM
            )
        )
        layout_data_vw_priority.text = tmpData.priority.toString()
        val colors: TypedArray = resources.obtainTypedArray(R.array.priority_colour)
        layout_data_vw.background = colors.getDrawable(tmpData.priority)
        colors.recycle()
    }
}