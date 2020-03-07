package com.sudeshi.iorgkt.db.repository

import androidx.lifecycle.LiveData
import com.sudeshi.iorgkt.db.dao.DataDAO
import com.sudeshi.iorgkt.db.model.Data

class DataRepository(private val dataDAO: DataDAO) {
    val allData: LiveData<List<Data>> = dataDAO.getAllMainData()
    suspend fun insert(data: Data) {
        dataDAO.insertMainData(data)
    }
}