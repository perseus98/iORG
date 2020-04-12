package com.sudeshi.iorgkt.viewModel

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.MutableLiveData
import java.time.OffsetDateTime
import java.time.ZoneId
import java.time.format.DateTimeFormatter.ofLocalizedDateTime
import java.time.format.FormatStyle

class DateViewModel(application: Application) : AndroidViewModel(application) {
    var dateTimeText: MutableLiveData<OffsetDateTime> =
        MutableLiveData(OffsetDateTime.now(ZoneId.systemDefault()))

    fun getDateTimeForTextView(): String? {
        return dateTimeText.value?.format(ofLocalizedDateTime(FormatStyle.MEDIUM))
    }

    fun getDateTimeForDB(): OffsetDateTime? {
        return dateTimeText.value
    }

    fun setNewDateTime(offsetDateRecvd: OffsetDateTime) {
        this.dateTimeText.value = offsetDateRecvd

    }
}