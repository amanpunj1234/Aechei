function GetSupportedMediaTypes() as Object
    return {
        "movie": "movies"
        "shortFormVideo": "shortFormVideos"
    }
end function

sub OnInputDeepLinking(event as Object)  
    args = event.getData()
    if args <> invalid and ValidateDeepLink(args) 
        DeepLink(m.Grid.content, args.mediaType, args.contentId)
    end if
end sub

function ValidateDeepLink(args as Object) as Boolean
    mediaType = args.mediaType
    contentId = args.contentId
    types = GetSupportedMediaTypes()
    return mediaType <> invalid and contentId <> invalid and types[mediaType] <> invalid
 end function

 sub DeepLink(content as Object, mediaType as String, contentId as String)

    playableItem = FindNodeById(content, contentId)
    types = GetSupportedMediaTypes()
    if playableItem <> invalid and playableItem.mediaType = types[mediaType]
        ClearScreen() 
        if mediaType = "shortFormVideo" or mediaType = "movie"
            HandlePlayableMediaTypes(playableItem)
        end if
    end if
end sub

sub HandlePlayableMediaTypes(content as Object)
    PrepareDetailsScreen(content) 
end sub

sub PrepareDetailsScreen(content as Object)
    m.deepLinkDetailsScreen = CreateObject("roSGNode", "DetailsScreen")
    m.deepLinkDetailsScreen.content = content
    m.deepLinkDetailsScreen.ObserveField("visible", "OnDeepLinkDetailsScreenVisibilityChanged")
    m.deepLinkDetailsScreen.ObserveField("buttonSelected", "OnDeepLinkDetailsScreenButtonSelected")
    AddScreen(m.deepLinkDetailsScreen)
end sub

sub OnDeepLinkDetailsScreenVisibilityChanged(event as Object) 
    visible = event.GetData()
    screen = event.GetRoSGNode()
    if visible = false and IsScreenAvailable(screen) = false
        content = screen.content
        if content <> invalid
            m.Grid.jumpToRowItem = [content.homeRowIndex, content.homeItemIndex]
            if m.deepLinkDetailsScreen <> invalid
                m.deepLinkDetailsScreen = invalid
            end if
        end if
    end if
end sub

sub OnDeepLinkDetailsScreenButtonSelected(event as Object) 
    buttonIndex = event.getData() 
    details = event.GetRoSGNode()
    button = details.buttons.getChild(buttonIndex)
    content = m.deepLinkDetailsScreen.content.clone(true)
    if button.id = "play"
        content.bookmarkPosition = 0
    end if
end sub

function FindNodeById(content as Object, contentId as String) as Object

    for each element in content.getChildren(-1, 0)
        if element.id = contentId
            return element
        else if element.getChildCount() > 0
            result = FindNodeById(element, contentId)
            if result <> invalid
                return result
            end if
        end if
    end for
    return invalid
end function
