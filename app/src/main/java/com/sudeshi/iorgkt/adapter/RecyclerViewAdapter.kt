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
import com.sudeshi.iorgkt.viewHolder.RecyclerViewHolder
import com.sudeshi.iorgkt.viewHolder.ViewHolderClickListener

class RecyclerViewAdapter(val context: Context, private val mainInterface: MainInterface) :
    RecyclerView.Adapter<RecyclerView.ViewHolder>(), ViewHolderClickListener {
    private var dataModelList: MutableList<Data> = ArrayList()
    val selectedIds: MutableList<Long> = ArrayList()

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
        return RecyclerViewHolder(
            LayoutInflater.from(parent.context)
                .inflate(R.layout.layout_recyclerview_model, parent, false), this
        )
    }

    override fun getItemCount(): Int = dataModelList.size
    fun getSelectedIdSize(): Int = selectedIds.size

    override fun onBindViewHolder(viewHolder: RecyclerView.ViewHolder, index: Int) {
        val dataViewHolder = viewHolder as RecyclerViewHolder
        dataViewHolder.bindView(dataModelList[index])
        val id = dataModelList[index].id
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

    fun setDataList(dataModelList: List<Data>) {
        this.dataModelList = dataModelList as MutableList<Data>
        notifyDataSetChanged()
    }

    fun clearSelection() {
        notifyDataSetChanged()
    }

    override fun onLongTap(index: Int) {
        if (!MainActivity.isMultiSelectOn) {
            MainActivity.isMultiSelectOn = true
        }
        addIDIntoSelectedIds(index)
        MainActivity.actionMode?.title = "" + getSelectedIdSize() + " items selected"
    }

    override fun onTap(index: Int) {
        if (MainActivity.isMultiSelectOn) {
            addIDIntoSelectedIds(index)
            MainActivity.actionMode?.title = "" + getSelectedIdSize() + " items selected"
        } else {
            Toast.makeText(context, "Clicked Item at Position ${index + 1}", Toast.LENGTH_SHORT)
                .show()
        }
    }

    private fun addIDIntoSelectedIds(index: Int) {
        val id = dataModelList[index].id
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
            val modelListIteration: MutableListIterator<Data> = dataModelList.listIterator()
            while (modelListIteration.hasNext()) {
                val model = modelListIteration.next()
                if (selectedItemID == model.id) {
                    modelListIteration.remove()
                    selectedIdIteration.remove()
                    MainActivity.dataViewModel.deleteEntry(model)
                    notifyItemRemoved(indexOfModelList)
                }
                indexOfModelList++
            }
            MainActivity.isMultiSelectOn = false
        }
    }

}