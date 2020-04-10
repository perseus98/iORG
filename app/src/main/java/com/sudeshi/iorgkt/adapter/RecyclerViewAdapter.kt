package com.sudeshi.iorgkt.adapter

import android.content.Context
import android.graphics.drawable.ColorDrawable
import android.view.LayoutInflater
import android.view.ViewGroup
import android.widget.Toast
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.RecyclerView
import com.sudeshi.iorgkt.R
import com.sudeshi.iorgkt.activity.MainActivity
import com.sudeshi.iorgkt.db.model.Data
import com.sudeshi.iorgkt.extension.MainInterface
import com.sudeshi.iorgkt.viewHolder.ViewHolderClickListener

class RecyclerViewAdapter(val context: Context, val mainInterface: MainInterface) :
    RecyclerView.Adapter<RecyclerView.ViewHolder>(), ViewHolderClickListener {
    private var dataList = listOf<Data>()
    var modelList: MutableList<Data> = ArrayList<Data>()
    val selectedIds: MutableList<Long> = ArrayList()

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
        return RecyclerViewHolder(
            LayoutInflater.from(parent.context)
                .inflate(R.layout.layout_recyclerview_model, parent, false), this
        )
    }

    override fun getItemCount(): Int = dataList.size

    override fun onBindViewHolder(viewHolder: RecyclerView.ViewHolder, index: Int) {
        val dataViewHolder = viewHolder as RecyclerViewHolder
        dataViewHolder.bindView(dataList[index])
        val id = dataList[index].id
        if (selectedIds.contains(id)) {
            //if item is selected then,set foreground color of FrameLayout.
            viewHolder.recyclerViewModel.foreground =
                ColorDrawable(ContextCompat.getColor(context, R.color.colorControlActivated))
        } else {
            //else remove selected item color.
            viewHolder.recyclerViewModel.foreground =
                ColorDrawable(ContextCompat.getColor(context, android.R.color.transparent))
        }
    }
    fun setDataList(dataList: List<Data>) {
        this.dataList = dataList
        notifyDataSetChanged()
    }

    override fun onLongTap(index: Int) {
        if (!MainActivity.isMultiSelectOn) {
            MainActivity.isMultiSelectOn = true
        }
        addIDIntoSelectedIds(index)
    }

    override fun onTap(index: Int) {
        if (MainActivity.isMultiSelectOn) {
            addIDIntoSelectedIds(index)
        } else {
            Toast.makeText(context, "Clicked Item @ Position ${index + 1}", Toast.LENGTH_SHORT)
                .show()
        }
    }

    fun addIDIntoSelectedIds(index: Int) {
        val id = dataList[index].id
        if (selectedIds.contains(id))
            selectedIds.remove(id)
        else
            selectedIds.add(id)

        notifyItemChanged(index)
        if (selectedIds.size < 1) MainActivity.isMultiSelectOn = false
        mainInterface.mainInterface(selectedIds.size)
    }

    fun deleteSelectedIds() {
        if (selectedIds.size < 1) return
        val selectedIdIteration = selectedIds.listIterator()

        while (selectedIdIteration.hasNext()) {
            val selectedItemID = selectedIdIteration.next()
            var indexOfModelList = 0
            val modelListIteration: MutableListIterator<Data> = modelList.listIterator()
            while (modelListIteration.hasNext()) {
                val model = modelListIteration.next()
                if (selectedItemID == model.id) {
                    modelListIteration.remove()
                    selectedIdIteration.remove()
                    notifyItemRemoved(indexOfModelList)
                }
                indexOfModelList++
            }

            MainActivity.isMultiSelectOn = false
        }
    }

}