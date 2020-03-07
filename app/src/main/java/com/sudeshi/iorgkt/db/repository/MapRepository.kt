package com.sudeshi.iorgkt.db.repository

import androidx.lifecycle.LiveData
import com.sudeshi.iorgkt.db.dao.MapDAO
import com.sudeshi.iorgkt.db.model.Map

class MapRepository(private val mapDao: MapDAO) {
    val allMapData: LiveData<List<Map>> = mapDao.getAllMapData()
    suspend fun insert(map: Map) {
        mapDao.insertMapData(map)
    }
}