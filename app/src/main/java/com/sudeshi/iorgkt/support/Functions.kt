package com.sudeshi.iorgkt.support

import android.app.DatePickerDialog
import java.text.SimpleDateFormat
import java.util.*

object Functions {
    private fun initChipGroup() {
//        chip.isClickable = true
//        chip.isCheckable = false
    }

    private fun initCalanderDialog() {
        val cal = Calendar.getInstance()
        val dateSetListener =
            DatePickerDialog.OnDateSetListener { _, year, monthOfYear, dayOfMonth ->
                cal.set(Calendar.YEAR, year)
                cal.set(Calendar.MONTH, monthOfYear)
                cal.set(Calendar.DAY_OF_MONTH, dayOfMonth)

                val myFormat = "dd/MM/yyyy, HH:mm:ss" // mention the format you need
                val sdf = SimpleDateFormat(myFormat, Locale.US)
//                outlinedTextCalander?.editTextCalander?.setText(sdf.format(cal.time))
            }

//        outlinedTextCalander.editTextCalander.setOnClickListener {
//            DatePickerDialog(
////                this@CreateActivity, R.style.styledatepicker, dateSetListener,
//                cal.get(Calendar.YEAR),
//                cal.get(Calendar.MONTH),
//                cal.get(Calendar.DAY_OF_MONTH)
//            ).show()
    }
}