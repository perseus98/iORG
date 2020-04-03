package com.sudeshi.iorgkt.viewModel

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.MutableLiveData
import java.time.OffsetDateTime
import java.time.ZoneId

class DateViewModel(application: Application) : AndroidViewModel(application) {
    var dateTimeText: MutableLiveData<OffsetDateTime> =
        MutableLiveData(OffsetDateTime.now(ZoneId.systemDefault()))

    fun getDateTime(): String? {
        return dateTimeText.value.toString()
    }

    fun setNewDateTime(offsetDateRecvd: OffsetDateTime) {
        this.dateTimeText.value = offsetDateRecvd

    }
}