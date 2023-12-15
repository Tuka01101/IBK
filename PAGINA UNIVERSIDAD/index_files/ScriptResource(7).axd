﻿Type.registerNamespace("Sys.Extended.UI"),Sys.Extended.UI.IDragSource=function(){},Sys.Extended.UI.IDragSource.prototype={get_dragDataType:function(){throw Error.notImplemented()},getDragData:function(){throw Error.notImplemented()},get_dragMode:function(){throw Error.notImplemented()},onDragStart:function(){throw Error.notImplemented()},onDrag:function(){throw Error.notImplemented()},onDragEnd:function(){throw Error.notImplemented()}},Sys.Extended.UI.IDragSource.registerInterface("Sys.Extended.UI.IDragSource"),Sys.Extended.UI.IDropTarget=function(){},Sys.Extended.UI.IDropTarget.prototype={get_dropTargetElement:function(){throw Error.notImplemented()},canDrop:function(){throw Error.notImplemented()},drop:function(){throw Error.notImplemented()},onDragEnterTarget:function(){throw Error.notImplemented()},onDragLeaveTarget:function(){throw Error.notImplemented()},onDragInTarget:function(){throw Error.notImplemented()}},Sys.Extended.UI.IDropTarget.registerInterface("Sys.Extended.UI.IDropTarget"),Sys.Extended.UI.DragMode=function(){throw Error.invalidOperation()},Sys.Extended.UI.DragMode.prototype={Copy:0,Move:1},Sys.Extended.UI.DragMode.registerEnum("Sys.Extended.UI.DragMode"),Sys.Extended.UI.DragDropEventArgs=function(e,t,r){this._dragMode=e,this._dataType=t,this._data=r},Sys.Extended.UI.DragDropEventArgs.prototype={get_dragMode:function(){return this._dragMode||null},get_dragDataType:function(){return this._dataType||null},get_dragData:function(){return this._data||null}},Sys.Extended.UI.DragDropEventArgs.registerClass("Sys.Extended.UI.DragDropEventArgs"),Sys.Extended.UI._DragDropManager=function(){this._instance=null,this._events=null},Sys.Extended.UI._DragDropManager.prototype={add_dragStart:function(e){this.get_events().addHandler("dragStart",e)},remove_dragStart:function(e){this.get_events().removeHandler("dragStart",e)},get_events:function(){return this._events||(this._events=new Sys.EventHandlerList),this._events},add_dragStop:function(e){this.get_events().addHandler("dragStop",e)},remove_dragStop:function(e){this.get_events().removeHandler("dragStop",e)},_getInstance:function(){return this._instance||(Sys.Browser.agent===Sys.Browser.InternetExplorer?this._instance=new Sys.Extended.UI.IEDragDropManager:this._instance=new Sys.Extended.UI.GenericDragDropManager,this._instance.initialize(),this._instance.add_dragStart(Function.createDelegate(this,this._raiseDragStart)),this._instance.add_dragStop(Function.createDelegate(this,this._raiseDragStop))),this._instance},startDragDrop:function(e,t,r,n){this._getInstance().startDragDrop(e,t,r,n)},registerDropTarget:function(e){this._getInstance().registerDropTarget(e)},unregisterDropTarget:function(e){this._getInstance().unregisterDropTarget(e)},dispose:function(){delete this._events,Sys.Application.unregisterDisposableObject(this),Sys.Application.removeComponent(this)},_raiseDragStart:function(e,t){var r=this.get_events().getHandler("dragStart");r&&r(this,t)},_raiseDragStop:function(e,t){var r=this.get_events().getHandler("dragStop");r&&r(this,t)}},Sys.Extended.UI._DragDropManager.registerClass("Sys.Extended.UI._DragDropManager"),Sys.Extended.UI.DragDropManager=new Sys.Extended.UI._DragDropManager,Sys.Extended.UI.IEDragDropManager=function(){Sys.Extended.UI.IEDragDropManager.initializeBase(this),this._dropTargets=null,this._radius=10,this._useBuiltInDragAndDropFunctions=!0,this._activeDragVisual=null,this._activeContext=null,this._activeDragSource=null,this._underlyingTarget=null,this._oldOffset=null,this._potentialTarget=null,this._isDragging=!1,this._mouseUpHandler=null,this._documentMouseMoveHandler=null,this._documentDragOverHandler=null,this._dragStartHandler=null,this._mouseMoveHandler=null,this._dragEnterHandler=null,this._dragLeaveHandler=null,this._dragOverHandler=null,this._dropHandler=null},Sys.Extended.UI.IEDragDropManager.prototype={add_dragStart:function(e){this.get_events().addHandler("dragStart",e)},remove_dragStart:function(e){this.get_events().removeHandler("dragStart",e)},add_dragStop:function(e){this.get_events().addHandler("dragStop",e)},remove_dragStop:function(e){this.get_events().removeHandler("dragStop",e)},initialize:function(){Sys.Extended.UI.IEDragDropManager.callBaseMethod(this,"initialize"),this._mouseUpHandler=Function.createDelegate(this,this._onMouseUp),this._documentMouseMoveHandler=Function.createDelegate(this,this._onDocumentMouseMove),this._documentDragOverHandler=Function.createDelegate(this,this._onDocumentDragOver),this._dragStartHandler=Function.createDelegate(this,this._onDragStart),this._mouseMoveHandler=Function.createDelegate(this,this._onMouseMove),this._dragEnterHandler=Function.createDelegate(this,this._onDragEnter),this._dragLeaveHandler=Function.createDelegate(this,this._onDragLeave),this._dragOverHandler=Function.createDelegate(this,this._onDragOver),this._dropHandler=Function.createDelegate(this,this._onDrop)},dispose:function(){if(this._dropTargets){for(var e=0;e<this._dropTargets;e++)this.unregisterDropTarget(this._dropTargets[e]);this._dropTargets=null}Sys.Extended.UI.IEDragDropManager.callBaseMethod(this,"dispose")},startDragDrop:function(e,t,r,n){var a=window._event;if(!this._isDragging){this._underlyingTarget=null,this._activeDragSource=e,this._activeDragVisual=t,this._activeContext=r,this._useBuiltInDragAndDropFunctions="undefined"==typeof n||n;var o={x:a.clientX,y:a.clientY};t.originalPosition=t.style.position,t.style.position="absolute",document._lastPosition=o,t.startingPoint=o;var i=this.getScrollOffset(t,!0);t.startingPoint=this.addPoints(t.startingPoint,i);var s=parseInt(t.style.left),d=parseInt(t.style.top);isNaN(s)&&(s="0"),isNaN(d)&&(d="0"),t.startingPoint=this.subtractPoints(t.startingPoint,{x:s,y:d}),this._prepareForDomChanges(),e.onDragStart();var g=new Sys.Extended.UI.DragDropEventArgs(e.get_dragMode(),e.get_dragDataType(),e.getDragData(r)),l=this.get_events().getHandler("dragStart");l&&l(this,g),this._recoverFromDomChanges(),this._wireEvents(),this._drag(!0)}},_stopDragDrop:function(e){var t=window._event;if(null!=this._activeDragSource){this._unwireEvents(),e||(e=null==this._underlyingTarget),e||null==this._underlyingTarget||this._underlyingTarget.drop(this._activeDragSource.get_dragMode(),this._activeDragSource.get_dragDataType(),this._activeDragSource.getDragData(this._activeContext)),this._activeDragSource.onDragEnd(e);var r=this.get_events().getHandler("dragStop");r&&r(this,Sys.EventArgs.Empty),this._activeDragVisual.style.position=this._activeDragVisual.originalPosition,this._activeDragSource=null,this._activeContext=null,this._activeDragVisual=null,this._isDragging=!1,this._potentialTarget=null,t.preventDefault()}},_drag:function(e){var t=window._event,r={x:t.clientX,y:t.clientY};document._lastPosition=r;var n=this.getScrollOffset(this._activeDragVisual,!0),a=this.addPoints(this.subtractPoints(r,this._activeDragVisual.startingPoint),n);if(e||parseInt(this._activeDragVisual.style.left)!=a.x||parseInt(this._activeDragVisual.style.top)!=a.y){$common.setLocation(this._activeDragVisual,a),this._prepareForDomChanges(),this._activeDragSource.onDrag(),this._recoverFromDomChanges(),this._potentialTarget=this._findPotentialTarget(this._activeDragSource,this._activeDragVisual);var o=this._potentialTarget!=this._underlyingTarget||null==this._potentialTarget;o&&null!=this._underlyingTarget&&this._leaveTarget(this._activeDragSource,this._underlyingTarget),null!=this._potentialTarget?o?(this._underlyingTarget=this._potentialTarget,this._enterTarget(this._activeDragSource,this._underlyingTarget)):this._moveInTarget(this._activeDragSource,this._underlyingTarget):this._underlyingTarget=null}},_wireEvents:function(){this._useBuiltInDragAndDropFunctions?($addHandler(document,"mouseup",this._mouseUpHandler),$addHandler(document,"mousemove",this._documentMouseMoveHandler),$addHandler(document.body,"dragover",this._documentDragOverHandler),$addHandler(this._activeDragVisual,"dragstart",this._dragStartHandler),$addHandler(this._activeDragVisual,"dragend",this._mouseUpHandler),$addHandler(this._activeDragVisual,"drag",this._mouseMoveHandler)):($addHandler(document,"mouseup",this._mouseUpHandler),$addHandler(document,"mousemove",this._mouseMoveHandler))},_unwireEvents:function(){this._useBuiltInDragAndDropFunctions?($removeHandler(this._activeDragVisual,"drag",this._mouseMoveHandler),$removeHandler(this._activeDragVisual,"dragend",this._mouseUpHandler),$removeHandler(this._activeDragVisual,"dragstart",this._dragStartHandler),$removeHandler(document.body,"dragover",this._documentDragOverHandler),$removeHandler(document,"mousemove",this._documentMouseMoveHandler),$removeHandler(document,"mouseup",this._mouseUpHandler)):($removeHandler(document,"mousemove",this._mouseMoveHandler),$removeHandler(document,"mouseup",this._mouseUpHandler))},registerDropTarget:function(e){null==this._dropTargets&&(this._dropTargets=[]),Array.add(this._dropTargets,e),this._wireDropTargetEvents(e)},unregisterDropTarget:function(e){this._unwireDropTargetEvents(e),this._dropTargets&&Array.remove(this._dropTargets,e)},_wireDropTargetEvents:function(e){var t=e.get_dropTargetElement();t._dropTarget=e,$addHandler(t,"dragenter",this._dragEnterHandler),$addHandler(t,"dragleave",this._dragLeaveHandler),$addHandler(t,"dragover",this._dragOverHandler),$addHandler(t,"drop",this._dropHandler)},_unwireDropTargetEvents:function(e){var t=e.get_dropTargetElement();t._dropTarget&&(t._dropTarget=null,$removeHandler(t,"dragenter",this._dragEnterHandler),$removeHandler(t,"dragleave",this._dragLeaveHandler),$removeHandler(t,"dragover",this._dragOverHandler),$removeHandler(t,"drop",this._dropHandler))},_onDragStart:function(e){window._event=e,document.selection.empty();var t=e.dataTransfer;!t&&e.rawEvent&&(t=e.rawEvent.dataTransfer);var r=this._activeDragSource.get_dragDataType().toLowerCase(),n=this._activeDragSource.getDragData(this._activeContext);n&&("text"!=r&&"url"!=r&&(r="text",null!=n.innerHTML&&(n=n.innerHTML)),t.effectAllowed="move",t.setData(r,n.toString()))},_onMouseUp:function(e){window._event=e,this._stopDragDrop(!1)},_onDocumentMouseMove:function(e){window._event=e,this._dragDrop()},_onDocumentDragOver:function(e){window._event=e,this._potentialTarget&&e.preventDefault()},_onMouseMove:function(e){window._event=e,this._drag()},_onDragEnter:function(e){if(window._event=e,this._isDragging)e.preventDefault();else for(var t=Sys.Extended.UI.IEDragDropManager._getDataObjectsForDropTarget(this._getDropTarget(e.target)),r=0;r<t.length;r++)this._dropTarget.onDragEnterTarget(Sys.Extended.UI.DragMode.Copy,t[r].type,t[r].value)},_onDragLeave:function(e){if(window._event=e,this._isDragging)e.preventDefault();else for(var t=Sys.Extended.UI.IEDragDropManager._getDataObjectsForDropTarget(this._getDropTarget(e.target)),r=0;r<t.length;r++)this._dropTarget.onDragLeaveTarget(Sys.Extended.UI.DragMode.Copy,t[r].type,t[r].value)},_onDragOver:function(e){if(window._event=e,this._isDragging)e.preventDefault();else for(var t=Sys.Extended.UI.IEDragDropManager._getDataObjectsForDropTarget(this._getDropTarget(e.target)),r=0;r<t.length;r++)this._dropTarget.onDragInTarget(Sys.Extended.UI.DragMode.Copy,t[r].type,t[r].value)},_onDrop:function(e){if(window._event=e,!this._isDragging)for(var t=Sys.Extended.UI.IEDragDropManager._getDataObjectsForDropTarget(this._getDropTarget(e.target)),r=0;r<t.length;r++)this._dropTarget.drop(Sys.Extended.UI.DragMode.Copy,t[r].type,t[r].value);e.preventDefault()},_getDropTarget:function(e){for(;e;){if(null!=e._dropTarget)return e._dropTarget;e=e.parentNode}return null},_dragDrop:function(){this._isDragging||(this._isDragging=!0,this._activeDragVisual.dragDrop(),document.selection.empty())},_moveInTarget:function(e,t){this._prepareForDomChanges(),t.onDragInTarget(e.get_dragMode(),e.get_dragDataType(),e.getDragData(this._activeContext)),this._recoverFromDomChanges()},_enterTarget:function(e,t){this._prepareForDomChanges(),t.onDragEnterTarget(e.get_dragMode(),e.get_dragDataType(),e.getDragData(this._activeContext)),this._recoverFromDomChanges()},_leaveTarget:function(e,t){this._prepareForDomChanges(),t.onDragLeaveTarget(e.get_dragMode(),e.get_dragDataType(),e.getDragData(this._activeContext)),this._recoverFromDomChanges()},_findPotentialTarget:function(e,t){var r=window._event;if(null==this._dropTargets)return null;for(var n,a=e.get_dragDataType(),o=e.get_dragMode(),i=e.getDragData(this._activeContext),s=this.getScrollOffset(document.body,!0),d=r.clientX+s.x,g=r.clientY+s.y,l={x:d-this._radius,y:g-this._radius,width:2*this._radius,height:2*this._radius},_=0;_<this._dropTargets.length;_++)if(n=$common.getBounds(this._dropTargets[_].get_dropTargetElement()),$common.overlaps(l,n)&&this._dropTargets[_].canDrop(o,a,i))return this._dropTargets[_];return null},_prepareForDomChanges:function(){this._oldOffset=$common.getLocation(this._activeDragVisual)},_recoverFromDomChanges:function(){var e=$common.getLocation(this._activeDragVisual);if(this._oldOffset.x!=e.x||this._oldOffset.y!=e.y){this._activeDragVisual.startingPoint=this.subtractPoints(this._activeDragVisual.startingPoint,this.subtractPoints(this._oldOffset,e)),scrollOffset=this.getScrollOffset(this._activeDragVisual,!0);var t=this.addPoints(this.subtractPoints(document._lastPosition,this._activeDragVisual.startingPoint),scrollOffset);$common.setLocation(this._activeDragVisual,t)}},addPoints:function(e,t){return{x:e.x+t.x,y:e.y+t.y}},subtractPoints:function(e,t){return{x:e.x-t.x,y:e.y-t.y}},getScrollOffset:function(e,t){var r=e.scrollLeft,n=e.scrollTop;if(t)for(var a=e.parentNode;null!=a&&null!=a.scrollLeft&&(r+=a.scrollLeft,n+=a.scrollTop,a!=document.body||0==r||0==n);)a=a.parentNode;return{x:r,y:n}},getBrowserRectangle:function(){var e=window.innerWidth,t=window.innerHeight;return null==e&&(e=document.documentElement.clientWidth),null==t&&(t=document.documentElement.clientHeight),{x:0,y:0,width:e,height:t}},getNextSibling:function(e){for(e=e.nextSibling;null!=e;e=e.nextSibling)if(null!=e.innerHTML)return e;return null},hasParent:function(e){return null!=e.parentNode&&null!=e.parentNode.tagName}},Sys.Extended.UI.IEDragDropManager.registerClass("Sys.Extended.UI.IEDragDropManager",Sys.Component),Sys.Extended.UI.IEDragDropManager._getDataObjectsForDropTarget=function(e){if(null==e)return[];for(var t,r=window._event,n=[],a=["URL","Text"],o=0;o<a.length;o++){var i=r.dataTransfer;!i&&r.rawEvent&&(i=r.rawEvent.dataTransfer),t=i.getData(a[o]),e.canDrop(Sys.Extended.UI.DragMode.Copy,a[o],t)&&t&&Array.add(n,{type:a[o],value:t})}return n},Sys.Extended.UI.GenericDragDropManager=function(){Sys.Extended.UI.GenericDragDropManager.initializeBase(this),this._dropTargets=null,this._scrollEdgeConst=40,this._scrollByConst=10,this._scroller=null,this._scrollDeltaX=0,this._scrollDeltaY=0,this._activeDragVisual=null,this._activeContext=null,this._activeDragSource=null,this._oldOffset=null,this._potentialTarget=null,this._mouseUpHandler=null,this._mouseMoveHandler=null,this._keyPressHandler=null,this._scrollerTickHandler=null},Sys.Extended.UI.GenericDragDropManager.prototype={initialize:function(){Sys.Extended.UI.GenericDragDropManager.callBaseMethod(this,"initialize"),this._mouseUpHandler=Function.createDelegate(this,this._onMouseUp),this._mouseMoveHandler=Function.createDelegate(this,this._onMouseMove),this._keyPressHandler=Function.createDelegate(this,this._onKeyPress),this._scrollerTickHandler=Function.createDelegate(this,this._onScrollerTick),this._scroller=new Sys.Timer,this._scroller.set_interval(10),this._scroller.add_tick(this._scrollerTickHandler)},startDragDrop:function(e,t,r){this._activeDragSource=e,this._activeDragVisual=t,this._activeContext=r,Sys.Extended.UI.GenericDragDropManager.callBaseMethod(this,"startDragDrop",[e,t,r])},_stopDragDrop:function(e){this._scroller.set_enabled(!1),Sys.Extended.UI.GenericDragDropManager.callBaseMethod(this,"_stopDragDrop",[e])},_drag:function(e){Sys.Extended.UI.GenericDragDropManager.callBaseMethod(this,"_drag",[e]),this._autoScroll()},_wireEvents:function(){$addHandler(document,"mouseup",this._mouseUpHandler),$addHandler(document,"mousemove",this._mouseMoveHandler),$addHandler(document,"keypress",this._keyPressHandler)},_unwireEvents:function(){$removeHandler(document,"keypress",this._keyPressHandler),$removeHandler(document,"mousemove",this._mouseMoveHandler),$removeHandler(document,"mouseup",this._mouseUpHandler)},_wireDropTargetEvents:function(e){},_unwireDropTargetEvents:function(e){},_onMouseUp:function(e){window._event=e,this._stopDragDrop(!1)},_onMouseMove:function(e){window._event=e,this._drag()},_onKeyPress:function(e){window._event=e;var t=e.keyCode?e.keyCode:e.rawEvent.keyCode;27==t&&this._stopDragDrop(!0)},_autoScroll:function(){var e=window._event,t=this.getBrowserRectangle();t.width>0&&(this._scrollDeltaX=this._scrollDeltaY=0,e.clientX<t.x+this._scrollEdgeConst?this._scrollDeltaX=-this._scrollByConst:e.clientX>t.width-this._scrollEdgeConst&&(this._scrollDeltaX=this._scrollByConst),e.clientY<t.y+this._scrollEdgeConst?this._scrollDeltaY=-this._scrollByConst:e.clientY>t.height-this._scrollEdgeConst&&(this._scrollDeltaY=this._scrollByConst),0!=this._scrollDeltaX||0!=this._scrollDeltaY?this._scroller.set_enabled(!0):this._scroller.set_enabled(!1))},_onScrollerTick:function(){var e=document.body.scrollLeft,t=document.body.scrollTop;window.scrollBy(this._scrollDeltaX,this._scrollDeltaY);var r=document.body.scrollLeft,n=document.body.scrollTop,a=this._activeDragVisual,o={x:parseInt(a.style.left)+(r-e),y:parseInt(a.style.top)+(n-t)};$common.setLocation(a,o)}},Sys.Extended.UI.GenericDragDropManager.registerClass("Sys.Extended.UI.GenericDragDropManager",Sys.Extended.UI.IEDragDropManager);