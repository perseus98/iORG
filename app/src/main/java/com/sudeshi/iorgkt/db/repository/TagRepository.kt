package com.sudeshi.iorgkt.db.repository

import androidx.lifecycle.LiveData
import com.sudeshi.iorgkt.db.dao.TagDAO
import com.sudeshi.iorgkt.db.model.Tag

class TagRepository(private val tagDAO: TagDAO) {
    val allTags: LiveData<List<Tag>> = tagDAO.getAllTags()
    suspend fun insert(tag: Tag) {
        tagDAO.insertTag(tag)
    }
}