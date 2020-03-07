package com.sudeshi.iorgkt.viewModel

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.viewModelScope
import com.sudeshi.iorgkt.db.IRoomDatabase
import com.sudeshi.iorgkt.db.model.Map
import com.sudeshi.iorgkt.db.repository.MapRepository
import kotlinx.coroutines.launch

class MapViewModel(application: Application) : AndroidViewModel(application) {
    private val mapRepository: MapRepository
    private val allMapData: LiveData<List<Map>>

    init {
        val mapDao = IRoomDatabase.getDatabase(application).mapDao()
        mapRepository = MapRepository(mapDao)
        allMapData = mapRepository.allMapData
    }

    fun insert(map: Map) = viewModelScope.launch {
        mapRepository.insert(map)
    }
}