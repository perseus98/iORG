package com.sudeshi.iorgkt.viewModel

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.viewModelScope
import com.sudeshi.iorgkt.db.IRoomDatabase
import com.sudeshi.iorgkt.db.model.Tag
import com.sudeshi.iorgkt.db.repository.TagRepository
import kotlinx.coroutines.launch

class TagViewModel(application: Application) : AndroidViewModel(application) {
    private val tagRepository: TagRepository
    private val allTag: LiveData<List<Tag>>

    init {
        val tagDao = IRoomDatabase.getDatabase(application).tagDao()
        tagRepository = TagRepository(tagDao)
        allTag = tagRepository.allTags
    }

    fun insert(tag: Tag) = viewModelScope.launch {
        tagRepository.insert(tag)
    }
}