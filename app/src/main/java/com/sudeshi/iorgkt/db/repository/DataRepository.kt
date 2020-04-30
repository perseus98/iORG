package com.sudeshi.iorgkt.db.repository

import androidx.annotation.WorkerThread
import androidx.lifecycle.LiveData
import com.sudeshi.iorgkt.db.dao.DataDAO
import com.sudeshi.iorgkt.db.model.Data

class DataRepository(private val dataDAO: DataDAO) {
    //    val allData: LiveData<List<Data>> = dataDAO.getAllDataEntry()
    suspend fun insert(data: Data) {
        dataDAO.insertMainData(data)
    }
    suspend fun delete(data: Data) {
        dataDAO.deleteDataEntry(data)
    }

    @WorkerThread
    fun search(desc: String): LiveData<List<Data>> {
        return dataDAO.searchDataEntry(desc)
    }
}