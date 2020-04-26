package com.sudeshi.iorgkt.viewModel

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.viewModelScope
import com.sudeshi.iorgkt.db.IRoomDatabase
import com.sudeshi.iorgkt.db.model.Data
import com.sudeshi.iorgkt.db.repository.DataRepository
import kotlinx.coroutines.launch

class DataViewModel(application: Application) : AndroidViewModel(application) {
    private val dataRepository: DataRepository
    val allData: LiveData<List<Data>>

    init {
        val dataDao = IRoomDatabase.getDatabase(application).dataDao()
        dataRepository = DataRepository(dataDao)
        allData = dataRepository.allData
    }

    fun insert(data: Data) = viewModelScope.launch {
        dataRepository.insert(data)
    }

    fun deleteEntry(data: Data) = viewModelScope.launch {
        dataRepository.delete(data)
    }

    fun searchEntry(srch_name: String) = viewModelScope.launch {
        dataRepository.searchItem(srch_name)
    }
}