﻿import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/components/card/"
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"

Item{
    id:root

    function empty(){
        return false
    }

    function refresh(){
    }

    function back(){
    }

    function search(keyword, pCursor = 0){
        busyBox.text = qsTr("Loading search result ...")
        busyBox.running = true
        if(0 === pCursor)
            resultModel.clear()
        AcService.search(keyword, pCursor, function(res){
            updateInfo(res)
        })
    }

    function updateInfo(js){
        if(0 !== js.result){
            busyBox.running = false
            PopMsg.showError(js, mainwindowRoot)
            return
        }

        var cnt = js.itemList.length
        console.log("search result num:"+cnt)
        for(var i=0;i<cnt;++i){
            var type = js.itemList[i].itemType
            if(type >2)
                continue
            resultModel.append({"info":js.itemList[i],
                                "type":type})
            console.log("search result append:"+js.itemList[i].title)
        }
        busyBox.running = false
    }

    ListModel {
        id:resultModel
    }
    GridView {
        id: cardView
        anchors.fill: parent
        anchors.margins: 0
        clip: true
        cellWidth: 205
        cellHeight: 205
        ScrollBar.vertical : ScrollBar{
            id: scrollbar
            anchors.right: cardView.right
            width: 10
        }

        model:  resultModel
        delegate: Item {
            id: deleCard
            width: 190
            height: 190
            Component{
                id: cmpVideo
                VideoInfoCard {
                    infoJs: {
                        "title": model.info.title,
                        "contentId": model.info.contentId,
                        "contentType": 2,
                        "videoCover": model.info.coverUrl,
                        "durationDisplay": model.info.playDuration,
                        "userName": model.info.userName,
                        "commentCountShow": model.info.commentCount,
                        "createTime": model.info.ctime,
                        "viewCountShow": model.info.viewCount,
                        "danmakuCountShow": model.info.danmuCount,
                        "description": model.info.decr
                    }
                }
            }
            Component {
                id: cmpUser
                UserInfoCard {
                    userJson: model.info
                }
            }
            Loader {
                id: barLoader
                sourceComponent: {
                    if(model.type === 1)//user
                        return cmpUser;
                    if(model.type === 2)//video
                        return cmpVideo;
                    return cmpUser;
                }
            }
        }
    }
}

