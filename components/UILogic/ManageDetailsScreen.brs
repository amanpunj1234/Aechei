sub ShowDetailsScreen(content as Object, selectedItem as Integer)
    detailsScreen = CreateObject("roSGNode", "Detail")
    detailsScreen.content = content
    detailsScreen.jumpToItem = selectedItem
    detailsScreen.ObserveField("visible", "OnDetailsScreenVisibilityChanged")
    detailsScreen.ObserveField("buttonSelected", "OnButtonSelected")
    ShowScreen(detailsScreen)
end sub

sub OnButtonSelected(event) 
    details = event.GetRoSGNode()
    content = details.content
    buttonIndex = event.getData()
    selectedItem = details.itemFocused
    if buttonIndex = 0 
        ShowVideoScreen(content, selectedItem)
    end if
end sub

sub OnDetailsScreenVisibilityChanged(event as Object) 
    visible = event.GetData()
    detailsScreen = event.GetRoSGNode()
    currentScreen = m.screenStack.Peek() 
    screenType = currentScreen.SubType()
    if screenType = "Grid"
        currentScreen.jumpToRowItem = [m.selectedIndex[0], detailsScreen.itemFocused]
        end if
end sub