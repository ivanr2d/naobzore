not = 'undefined';

//
(function($){"function"!=typeof $.support.selectstart&&($.support.selectstart="onselectstart"in document.createElement("div")),"function"!=typeof $.fn.disableSelection&&($.fn.disableSelection=function(){return this.bind(($.support.selectstart?"selectstart":"mousedown")+".ui-disableSelection",function(t){t.preventDefault()})}),$.addFlex=function(t,p){if(t.grid)return!1;p=$.extend({height:200,width:"auto",striped:!0,novstripe:!1,minwidth:30,minheight:80,resizable:!0,url:!1,method:"POST",dataType:"xml",errormsg:"Connection Error",usepager:!1,nowrap:!0,page:1,total:1,useRp:!0,rp:15,rpOptions:[10,15,20,30,50],title:!1,idProperty:"id",pagestat:"Displaying {from} to {to} of {total} items",pagetext:"Page",outof:"of",findtext:"Find",params:[],procmsg:"Processing, please wait ...",query:"",qtype:"",nomsg:"No items",minColToggle:1,showToggleBtn:!0,hideOnSubmit:!0,autoload:!0,blockOpacity:.5,preProcess:!1,addTitleToCell:!1,dblClickResize:!1,onDragCol:!1,onToggleCol:!1,onChangeSort:!1,onDoubleClick:!1,onSuccess:!1,onError:!1,onSubmit:!1,__mw:{datacol:function(t,e,i){var s="function"==typeof t.datacol[e]?t.datacol[e](i):i;return"function"==typeof t.datacol["*"]?t.datacol["*"](s):s}},getGridClass:function(t){return t},datacol:{},colResize:!0,colMove:!0},p),$(t).show().attr({cellPadding:0,cellSpacing:0,border:0}).removeAttr("width");var g={hset:{},rePosDrag:function(){var t=0-this.hDiv.scrollLeft;this.hDiv.scrollLeft>0&&(t-=Math.floor(p.cgwidth/2)),$(g.cDrag).css({top:g.hDiv.offsetTop+1});var e,i=this.cdpad;$("div",g.cDrag).hide(),$("thead tr:first th:visible",this.hDiv).each(function(){var s=$("thead tr:first th:visible",g.hDiv).index(this),n=parseInt($("div",this).width());0==t&&(t-=Math.floor(p.cgwidth/2)),n=n+t+i,isNaN(n)&&(n=0),$("div:eq("+s+")",g.cDrag).css({left:($.browser.mozilla?n:n-e)+"px"}).show(),t=n,e++})},fixHeight:function(t){t=!1,t||(t=$(g.bDiv).height());var e=$(this.hDiv).height();$("div",this.cDrag).each(function(){$(this).height(t+e)});var i=parseInt($(g.nDiv).height(),10);i>t?$(g.nDiv).height(t).width(200):$(g.nDiv).height("auto").width("auto"),$(g.block).css({height:t,marginBottom:-1*t});var s=g.bDiv.offsetTop+t;"auto"!=p.height&&p.resizable&&(s=g.vDiv.offsetTop),$(g.rDiv).css({height:s})},dragStart:function(t,e,i){if("colresize"==t&&p.colResize===!0){$(g.nDiv).hide(),$(g.nBtn).hide();var s=$("div",this.cDrag).index(i),n=$("th:visible div:eq("+s+")",this.hDiv).width();$(i).addClass("dragging").siblings().hide(),$(i).prev().addClass("dragging").show(),this.colresize={startX:e.pageX,ol:parseInt(i.style.left,10),ow:n,n:s},$("body").css("cursor","col-resize")}else if("vresize"==t){var o=!1;$("body").css("cursor","row-resize"),i&&(o=!0,$("body").css("cursor","col-resize")),this.vresize={h:p.height,sy:e.pageY,w:p.width,sx:e.pageX,hgo:o}}else"colMove"==t&&($(e.target).disableSelection(),p.colMove===!0&&($(g.nDiv).hide(),$(g.nBtn).hide(),this.hset=$(this.hDiv).offset(),this.hset.right=this.hset.left+$("table",this.hDiv).width(),this.hset.bottom=this.hset.top+$("table",this.hDiv).height(),this.dcol=i,this.dcoln=$("th",this.hDiv).index(i),this.colCopy=document.createElement("div"),this.colCopy.className="colCopy",this.colCopy.innerHTML=i.innerHTML,$.browser.msie&&(this.colCopy.className="colCopy ie"),$(this.colCopy).css({position:"absolute","float":"left",display:"none",textAlign:i.align}),$("body").append(this.colCopy),$(this.cDrag).hide()));$("body").noSelect()},dragMove:function(t){if(this.colresize){var e=this.colresize.n,i=t.pageX-this.colresize.startX,s=this.colresize.ol+i,n=this.colresize.ow+i;n>p.minwidth&&($("div:eq("+e+")",this.cDrag).css("left",s),this.colresize.nw=n)}else if(this.vresize){var o=this.vresize,a=t.pageY,i=a-o.sy;if(p.defwidth||(p.defwidth=p.width),"auto"!=p.width&&!p.nohresize&&o.hgo){var r=t.pageX,l=r-o.sx,c=o.w+l;c>p.defwidth&&(this.gDiv.style.width=c+"px",p.width=c)}var d=o.h+i;(d>p.minheight||p.minheight>p.height)&&!o.hgo&&(this.bDiv.style.height=d+"px",p.height=d,this.fixHeight(d)),o=null}else this.colCopy&&($(this.dcol).addClass("thMove").removeClass("thOver"),t.pageX>this.hset.right||this.hset.left>t.pageX||t.pageY>this.hset.bottom||this.hset.top>t.pageY?$("body").css("cursor","move"):$("body").css("cursor","pointer"),$(this.colCopy).css({top:t.pageY+10,left:t.pageX+20,display:"block"}))},dragEnd:function(){if(this.colresize){var t=this.colresize.n,e=this.colresize.nw;if($("th:visible div:eq("+t+")",this.hDiv).css("width",e),$("tr",this.bDiv).each(function(){var i=$("td:visible div:eq("+t+")",this);i.css("width",e),g.addTitleToCell(i)}),this.hDiv.scrollLeft=this.bDiv.scrollLeft,$("div:eq("+t+")",this.cDrag).siblings().show(),$(".dragging",this.cDrag).removeClass("dragging"),this.rePosDrag(),this.fixHeight(),this.colresize=!1,$.cookies){var i=p.colModel[t].name;$.cookie("flexiwidths/"+i,e)}}else this.vresize?this.vresize=!1:this.colCopy&&($(this.colCopy).remove(),null!==this.dcolt&&(this.dcoln>this.dcolt?$("th:eq("+this.dcolt+")",this.hDiv).before(this.dcol):$("th:eq("+this.dcolt+")",this.hDiv).after(this.dcol),this.switchCol(this.dcoln,this.dcolt),$(this.cdropleft).remove(),$(this.cdropright).remove(),this.rePosDrag(),p.onDragCol&&p.onDragCol(this.dcoln,this.dcolt)),this.dcol=null,this.hset=null,this.dcoln=null,this.dcolt=null,this.colCopy=null,$(".thMove",this.hDiv).removeClass("thMove"),$(this.cDrag).show());$("body").css("cursor","default"),$("body").noSelect(!1)},toggleCol:function(e,i){var s=$("th[axis='col"+e+"']",this.hDiv)[0],n=$("thead th",g.hDiv).index(s),o=$("input[value="+e+"]",g.nDiv)[0];return null===i&&(i=s.hidden),p.minColToggle>$("input:checked",g.nDiv).length&&!i?!1:(i?(s.hidden=!1,$(s).show(),o.checked=!0):(s.hidden=!0,$(s).hide(),o.checked=!1),$("tbody tr",t).each(function(){i?$("td:eq("+n+")",this).show():$("td:eq("+n+")",this).hide()}),this.rePosDrag(),p.onToggleCol&&p.onToggleCol(e,i),i)},switchCol:function(e,i){$("tbody tr",t).each(function(){e>i?$("td:eq("+i+")",this).before($("td:eq("+e+")",this)):$("td:eq("+i+")",this).after($("td:eq("+e+")",this))}),e>i?$("tr:eq("+i+")",this.nDiv).before($("tr:eq("+e+")",this.nDiv)):$("tr:eq("+i+")",this.nDiv).after($("tr:eq("+e+")",this.nDiv)),$.browser.msie&&7>$.browser.version&&($("tr:eq("+i+") input",this.nDiv)[0].checked=!0),this.hDiv.scrollLeft=this.bDiv.scrollLeft},scroll:function(){this.hDiv.scrollLeft=this.bDiv.scrollLeft,this.rePosDrag()},addData:function(e){if("json"==p.dataType&&(e=$.extend({rows:[],page:0,total:0},e)),p.preProcess&&(e=p.preProcess(e)),$(".pReload",this.pDiv).removeClass("loading"),this.loading=!1,!e)return $(".pPageStat",this.pDiv).html(p.errormsg),p.onSuccess&&p.onSuccess(this),!1;if(p.total="xml"==p.dataType?+$("rows total",e).text():e.total,0===p.total)return $("tr, a, td, div",t).unbind(),$(t).empty(),p.pages=1,p.page=1,this.buildpager(),$(".pPageStat",this.pDiv).html(p.nomsg),p.onSuccess&&p.onSuccess(this),!1;p.pages=Math.ceil(p.total/p.rp),p.page="xml"==p.dataType?+$("rows page",e).text():e.page,this.buildpager();var i=document.createElement("tbody");if("json"==p.dataType)$.each(e.rows,function(t,e){var s=document.createElement("tr");if(e.name&&(s.name=e.name),e.color?$(s).css("background",e.color):t%2&&p.striped&&(s.className="erow"),e[p.idProperty]&&(s.id="row"+e[p.idProperty]),$("thead tr:first th",g.hDiv).each(function(){var t=document.createElement("td"),i=$(this).attr("axis").substr(3);if(t.align=this.align,e.cell===void 0)t.innerHTML=e[p.colModel[i].name];else{var n="";n=e.cell[i]!==void 0?null!==e.cell[i]?e.cell[i]:"":e.cell[p.colModel[i].name],t.innerHTML=p.__mw.datacol(p,$(this).attr("abbr"),n)}var o=t.innerHTML.indexOf("<BGCOLOR=");o>0&&$(t).css("background",text.substr(o+7,7)),$(t).attr("abbr",$(this).attr("abbr")),$(s).append(t),t=null}),1>$("thead",this.gDiv).length)for(idx=0;cell.length>idx;idx++){var n=document.createElement("td");n.innerHTML=e.cell[idx]!==void 0?null!=e.cell[idx]?e.cell[idx]:"":e.cell[p.colModel[idx].name],$(s).append(n),n=null}$(i).append(s),s=null});else if("xml"==p.dataType){var s=1;$("rows row",e).each(function(){s++;var t=document.createElement("tr");$(this).attr("name")&&(t.name=$(this).attr("name")),$(this).attr("color")?$(t).css("background",$(this).attr("id")):s%2&&p.striped&&(t.className="erow");var e=$(this).attr("id");e&&(t.id="row"+e),e=null;var n=this;$("thead tr:first th",g.hDiv).each(function(){var e=document.createElement("td"),i=$(this).attr("axis").substr(3);e.align=this.align;var s=$("cell:eq("+i+")",n).text(),o=s.indexOf("<BGCOLOR=");o>0&&$(e).css("background",s.substr(o+7,7)),e.innerHTML=p.__mw.datacol(p,$(this).attr("abbr"),s),$(e).attr("abbr",$(this).attr("abbr")),$(t).append(e),e=null}),1>$("thead",this.gDiv).length&&$("cell",this).each(function(){var e=document.createElement("td");e.innerHTML=$(this).text(),$(t).append(e),e=null}),$(i).append(t),t=null,n=null})}$("tr",t).unbind(),$(t).empty(),$(t).append(i),this.addCellProp(),this.addRowProp(),this.rePosDrag(),i=null,e=null,s=null,p.onSuccess&&p.onSuccess(this),p.hideOnSubmit&&$(g.block).remove(),this.hDiv.scrollLeft=this.bDiv.scrollLeft,$.browser.opera&&$(t).css("visibility","visible")},changeSort:function(t){return this.loading?!0:($(g.nDiv).hide(),$(g.nBtn).hide(),p.sortname==$(t).attr("abbr")&&(p.sortorder="asc"==p.sortorder?"desc":"asc"),$(t).addClass("sorted").siblings().removeClass("sorted"),$(".sdesc",this.hDiv).removeClass("sdesc"),$(".sasc",this.hDiv).removeClass("sasc"),$("div",t).addClass("s"+p.sortorder),p.sortname=$(t).attr("abbr"),p.onChangeSort?p.onChangeSort(p.sortname,p.sortorder):this.populate(),void 0)},buildpager:function(){$(".pcontrol input",this.pDiv).val(p.page),$(".pcontrol span",this.pDiv).html(p.pages);var t=(p.page-1)*p.rp+1,e=t+p.rp-1;e>p.total&&(e=p.total);var i=p.pagestat;i=i.replace(/{from}/,t),i=i.replace(/{to}/,e),i=i.replace(/{total}/,p.total),$(".pPageStat",this.pDiv).html(i)},populate:function(){if(this.loading)return!0;if(p.onSubmit){var e=p.onSubmit();if(!e)return!1}if(this.loading=!0,!p.url)return!1;$(".pPageStat",this.pDiv).html(p.procmsg),$(".pReload",this.pDiv).addClass("loading"),$(g.block).css({top:g.bDiv.offsetTop}),p.hideOnSubmit&&$(this.gDiv).prepend(g.block),$.browser.opera&&$(t).css("visibility","hidden"),p.newp||(p.newp=1),p.page>p.pages&&(p.page=p.pages);var i=[{name:"page",value:p.newp},{name:"rp",value:p.rp},{name:"sortname",value:p.sortname},{name:"sortorder",value:p.sortorder},{name:"query",value:p.query},{name:"qtype",value:p.qtype}];if(p.params.length)for(var s=0;p.params.length>s;s++)i[i.length]=p.params[s];$.ajax({type:p.method,url:p.url,data:i,dataType:p.dataType,success:function(t){g.addData(t)},error:function(t,e,i){try{p.onError&&p.onError(t,e,i)}catch(s){}}})},doSearch:function(){p.query=$("input[name=q]",g.sDiv).val(),p.qtype=$("select[name=qtype]",g.sDiv).val(),p.newp=1,this.populate()},changePage:function(t){if(this.loading)return!0;switch(t){case"first":p.newp=1;break;case"prev":p.page>1&&(p.newp=parseInt(p.page,10)-1);break;case"next":p.pages>p.page&&(p.newp=parseInt(p.page,10)+1);break;case"last":p.newp=p.pages;break;case"input":var e=parseInt($(".pcontrol input",this.pDiv).val(),10);isNaN(e)&&(e=1),1>e?e=1:e>p.pages&&(e=p.pages),$(".pcontrol input",this.pDiv).val(e),p.newp=e}return p.newp==p.page?!1:(p.onChangePage?p.onChangePage(p.newp):this.populate(),void 0)},addCellProp:function(){$("tbody tr td",g.bDiv).each(function(){var t=document.createElement("div"),e=$("td",$(this).parent()).index(this),i=$("th:eq("+e+")",g.hDiv).get(0);null!=i&&(p.sortname==$(i).attr("abbr")&&p.sortname&&(this.className="sorted"),$(t).css({textAlign:i.align,width:$("div:first",i)[0].style.width}),i.hidden&&$(this).css("display","none")),0==p.nowrap&&$(t).css("white-space","normal"),""==this.innerHTML&&(this.innerHTML="&nbsp;"),t.innerHTML=this.innerHTML;var s=$(this).parent()[0],n=!1;s.id&&(n=s.id.substr(3)),null!=i&&i.process&&i.process(t,n),$(this).empty().append(t).removeAttr("width"),g.addTitleToCell(t)})},getCellDim:function(t){var e=parseInt($(t).height(),10),i=parseInt($(t).parent().height(),10),s=parseInt(t.style.width,10),n=parseInt($(t).parent().width(),10),o=t.offsetParent.offsetTop,a=t.offsetParent.offsetLeft,r=parseInt($(t).css("paddingLeft"),10),l=parseInt($(t).css("paddingTop"),10);return{ht:e,wt:s,top:o,left:a,pdl:r,pdt:l,pht:i,pwt:n}},addRowProp:function(){$("tbody tr",g.bDiv).on("click",function(t){var e=t.target||t.srcElement;return e.href||e.type?!0:(t.ctrlKey||t.metaKey||($(this).toggleClass("trSelected"),p.singleSelect&&!g.multisel&&$(this).siblings().removeClass("trSelected")),void 0)}).on("mousedown",function(t){t.shiftKey&&($(this).toggleClass("trSelected"),g.multisel=!0,this.focus(),$(g.gDiv).noSelect()),(t.ctrlKey||t.metaKey)&&($(this).toggleClass("trSelected"),g.multisel=!0,this.focus())}).on("mouseup",function(t){!g.multisel||t.ctrlKey||t.metaKey||(g.multisel=!1,$(g.gDiv).noSelect(!1))}).on("dblclick",function(){p.onDoubleClick&&p.onDoubleClick(this,g,p)}).hover(function(t){g.multisel&&t.shiftKey&&$(this).toggleClass("trSelected")},function(){}),$.browser.msie&&7>$.browser.version&&$(this).hover(function(){$(this).addClass("trOver")},function(){$(this).removeClass("trOver")})},combo_flag:!0,combo_resetIndex:function(t){this.combo_flag&&(t.selectedIndex=0),this.combo_flag=!0},combo_doSelectAction:function(selObj){eval(selObj.options[selObj.selectedIndex].value),selObj.selectedIndex=0,this.combo_flag=!1},addTitleToCell:function(t){if(p.addTitleToCell){var e=$("<span />").css("display","none"),i=t instanceof jQuery?t:$(t),s=i.outerWidth(),n=0;$("body").children(":first").before(e),e.html(i.html()),e.css("font-size",""+i.css("font-size")),e.css("padding-left",""+i.css("padding-left")),n=e.innerWidth(),e.remove(),n>s?i.attr("title",i.text()):i.removeAttr("title")}},autoResizeColumn:function(t){if(p.dblClickResize){var e=$("div",this.cDrag).index(t),i=$("th:visible div:eq("+e+")",this.hDiv),s=parseInt(t.style.left,10),n=i.width(),o=0,a=0,r=$("<span />");$("body").children(":first").before(r),r.html(i.html()),r.css("font-size",""+i.css("font-size")),r.css("padding-left",""+i.css("padding-left")),r.css("padding-right",""+i.css("padding-right")),o=r.width(),$("tr",this.bDiv).each(function(){var t=$("td:visible div:eq("+e+")",this),i=0;r.html(t.html()),r.css("font-size",""+t.css("font-size")),r.css("padding-left",""+t.css("padding-left")),r.css("padding-right",""+t.css("padding-right")),i=r.width(),o=i>o?i:o}),r.remove(),o=p.minWidth>o?p.minWidth:o,a=s+(o-n),$("div:eq("+e+")",this.cDrag).css("left",a),this.colresize={nw:o,n:e},g.dragEnd()}},pager:0};if(g=p.getGridClass(g),p.colModel){thead=document.createElement("thead");for(var tr=document.createElement("tr"),i=0;p.colModel.length>i;i++){var cm=p.colModel[i],th=document.createElement("th");if($(th).attr("axis","col"+i),cm){if($.cookies){var cookie_width="flexiwidths/"+cm.name;void 0!=$.cookie(cookie_width)&&(cm.width=$.cookie(cookie_width))}void 0!=cm.display&&(th.innerHTML=cm.display),cm.name&&cm.sortable&&$(th).attr("abbr",cm.name),cm.align&&(th.align=cm.align),cm.width&&$(th).attr("width",cm.width),$(cm).attr("hide")&&(th.hidden=!0),cm.process&&(th.process=cm.process)}else th.innerHTML="",$(th).attr("width",30);$(tr).append(th)}$(thead).append(tr),$(t).prepend(thead)}if(g.gDiv=document.createElement("div"),g.mDiv=document.createElement("div"),g.hDiv=document.createElement("div"),g.bDiv=document.createElement("div"),g.vDiv=document.createElement("div"),g.rDiv=document.createElement("div"),g.cDrag=document.createElement("div"),g.block=document.createElement("div"),g.nDiv=document.createElement("div"),g.nBtn=document.createElement("div"),g.iDiv=document.createElement("div"),g.tDiv=document.createElement("div"),g.sDiv=document.createElement("div"),g.pDiv=document.createElement("div"),p.colResize===!1&&$(g.cDrag).css("display","none"),p.usepager||(g.pDiv.style.display="none"),g.hTable=document.createElement("table"),g.gDiv.className="flexigrid","auto"!=p.width&&(g.gDiv.style.width=p.width+"px"),$.browser.msie&&$(g.gDiv).addClass("ie"),p.novstripe&&$(g.gDiv).addClass("novstripe"),$(t).before(g.gDiv),$(g.gDiv).append(t),p.buttons){g.tDiv.className="tDiv";var tDiv2=document.createElement("div");tDiv2.className="tDiv2";for(var i=0;p.buttons.length>i;i++){var btn=p.buttons[i];if(btn.separator)$(tDiv2).append("<div class='btnseparator'></div>");else{var btnDiv=document.createElement("div");btnDiv.className="fbutton",btnDiv.innerHTML="<div><span>"+(btn.hidename?"&nbsp;":btn.name)+"</span></div>",btn.bclass&&$("span",btnDiv).addClass(btn.bclass).css({paddingLeft:20}),btn.bimage&&$("span",btnDiv).css("background","url("+btn.bimage+") no-repeat center left"),$("span",btnDiv).css("paddingLeft",20),btn.tooltip&&($("span",btnDiv)[0].title=btn.tooltip),btnDiv.onpress=btn.onpress,btnDiv.name=btn.name,btn.id&&(btnDiv.id=btn.id),btn.onpress&&$(btnDiv).click(function(){this.onpress(this.id||this.name,g.gDiv)}),$(tDiv2).append(btnDiv),$.browser.msie&&7>$.browser.version&&$(btnDiv).hover(function(){$(this).addClass("fbOver")},function(){$(this).removeClass("fbOver")})}}$(g.tDiv).append(tDiv2),$(g.tDiv).append("<div style='clear:both'></div>"),$(g.gDiv).prepend(g.tDiv)}if(g.hDiv.className="hDiv",p.combobuttons&&$(g.tDiv2)){var btnDiv=document.createElement("div");btnDiv.className="fbutton";var tSelect=document.createElement("select");for($(tSelect).change(function(){g.combo_doSelectAction(tSelect)}),$(tSelect).click(function(){g.combo_resetIndex(tSelect)}),tSelect.className="cselect",$(btnDiv).append(tSelect),i=0;p.combobuttons.length>i;i++){var btn=p.combobuttons[i];if(!btn.separator){var btnOpt=document.createElement("option");btnOpt.innerHTML=btn.name,btn.bclass&&$(btnOpt).addClass(btn.bclass).css({paddingLeft:20}),btn.bimage&&$(btnOpt).css("background","url("+btn.bimage+") no-repeat center left"),$(btnOpt).css("paddingLeft",20),btn.tooltip&&($(btnOpt)[0].title=btn.tooltip),btn.onpress&&(btnOpt.value=btn.onpress),$(tSelect).append(btnOpt)}}$(".tDiv2").append(btnDiv)}$(t).before(g.hDiv),g.hTable.cellPadding=0,g.hTable.cellSpacing=0,$(g.hDiv).append('<div class="hDivBox"></div>'),$("div",g.hDiv).append(g.hTable);var thead=$("thead:first",t).get(0);if(thead&&$(g.hTable).append(thead),thead=null,!p.colmodel)var ci=0;if($("thead tr:first th",g.hDiv).each(function(){var t=document.createElement("div");$(this).attr("abbr")&&($(this).click(function(t){if(!$(this).hasClass("thOver"))return!1;var e=t.target||t.srcElement;return e.href||e.type?!0:(g.changeSort(this),void 0)}),$(this).attr("abbr")==p.sortname&&(this.className="sorted",t.className="s"+p.sortorder)),this.hidden&&$(this).hide(),p.colmodel||$(this).attr("axis","col"+ci++),$(t).css({textAlign:this.align,width:this.width+"px"}),t.innerHTML=this.innerHTML,$(this).empty().append(t).removeAttr("width").mousedown(function(t){g.dragStart("colMove",t,this)}).hover(function(){if(g.colresize||$(this).hasClass("thMove")||g.colCopy||$(this).addClass("thOver"),$(this).attr("abbr")==p.sortname||g.colCopy||g.colresize||!$(this).attr("abbr")){if($(this).attr("abbr")==p.sortname&&!g.colCopy&&!g.colresize&&$(this).attr("abbr")){var t="asc"==p.sortorder?"desc":"asc";$("div",this).removeClass("s"+p.sortorder).addClass("s"+t)}}else $("div",this).addClass("s"+p.sortorder);if(g.colCopy){var e=$("th",g.hDiv).index(this);if(e==g.dcoln)return!1;g.dcoln>e?$(this).append(g.cdropleft):$(this).append(g.cdropright),g.dcolt=e}else if(!g.colresize){var i=$("th:visible",g.hDiv).index(this),s=parseInt($("div:eq("+i+")",g.cDrag).css("left"),10),n=jQuery(g.nBtn).outerWidth(),o=s-n+Math.floor(p.cgwidth/2);$(g.nDiv).hide(),$(g.nBtn).hide(),$(g.nBtn).css({left:o,top:g.hDiv.offsetTop}).show();var a=parseInt($(g.nDiv).width(),10);$(g.nDiv).css({top:g.bDiv.offsetTop}),o+a>$(g.gDiv).width()?$(g.nDiv).css("left",s-a+1):$(g.nDiv).css("left",o),$(this).hasClass("sorted")?$(g.nBtn).addClass("srtd"):$(g.nBtn).removeClass("srtd")}},function(){if($(this).removeClass("thOver"),$(this).attr("abbr")!=p.sortname)$("div",this).removeClass("s"+p.sortorder);else if($(this).attr("abbr")==p.sortname){var t="asc"==p.sortorder?"desc":"asc";$("div",this).addClass("s"+p.sortorder).removeClass("s"+t)}g.colCopy&&($(g.cdropleft).remove(),$(g.cdropright).remove(),g.dcolt=null)})}),g.bDiv.className="bDiv",$(t).before(g.bDiv),$(g.bDiv).css({height:"auto"==p.height?"auto":p.height+"px"}).scroll(function(){g.scroll()}).append(t),"auto"==p.height&&$("table",g.bDiv).addClass("autoht"),g.addCellProp(),g.addRowProp(),p.colResize===!0){var cdcol=$("thead tr:first th:first",g.hDiv).get(0);if(null!==cdcol){g.cDrag.className="cDrag",g.cdpad=0,g.cdpad+=isNaN(parseInt($("div",cdcol).css("borderLeftWidth"),10))?0:parseInt($("div",cdcol).css("borderLeftWidth"),10),g.cdpad+=isNaN(parseInt($("div",cdcol).css("borderRightWidth"),10))?0:parseInt($("div",cdcol).css("borderRightWidth"),10),g.cdpad+=isNaN(parseInt($("div",cdcol).css("paddingLeft"),10))?0:parseInt($("div",cdcol).css("paddingLeft"),10),g.cdpad+=isNaN(parseInt($("div",cdcol).css("paddingRight"),10))?0:parseInt($("div",cdcol).css("paddingRight"),10),g.cdpad+=isNaN(parseInt($(cdcol).css("borderLeftWidth"),10))?0:parseInt($(cdcol).css("borderLeftWidth"),10),g.cdpad+=isNaN(parseInt($(cdcol).css("borderRightWidth"),10))?0:parseInt($(cdcol).css("borderRightWidth"),10),g.cdpad+=isNaN(parseInt($(cdcol).css("paddingLeft"),10))?0:parseInt($(cdcol).css("paddingLeft"),10),g.cdpad+=isNaN(parseInt($(cdcol).css("paddingRight"),10))?0:parseInt($(cdcol).css("paddingRight"),10),$(g.bDiv).before(g.cDrag);var cdheight=$(g.bDiv).height(),hdheight=$(g.hDiv).height();$(g.cDrag).css({top:-hdheight+"px"}),$("thead tr:first th",g.hDiv).each(function(){var t=document.createElement("div");$(g.cDrag).append(t),p.cgwidth||(p.cgwidth=$(t).width()),$(t).css({height:cdheight+hdheight}).mousedown(function(t){g.dragStart("colresize",t,this)}).dblclick(function(){g.autoResizeColumn(this)}),$.browser.msie&&7>$.browser.version&&(g.fixHeight($(g.gDiv).height()),$(t).hover(function(){g.fixHeight(),$(this).addClass("dragging")},function(){g.colresize||$(this).removeClass("dragging")}))})}}if(p.striped&&$("tbody tr:odd",g.bDiv).addClass("erow"),p.resizable&&"auto"!=p.height&&(g.vDiv.className="vGrip",$(g.vDiv).mousedown(function(t){g.dragStart("vresize",t)}).html("<span></span>"),$(g.bDiv).after(g.vDiv)),p.resizable&&"auto"!=p.width&&!p.nohresize&&(g.rDiv.className="hGrip",$(g.rDiv).mousedown(function(t){g.dragStart("vresize",t,!0)}).html("<span></span>").css("height",$(g.gDiv).height()),$.browser.msie&&7>$.browser.version&&$(g.rDiv).hover(function(){$(this).addClass("hgOver")},function(){$(this).removeClass("hgOver")}),$(g.gDiv).append(g.rDiv)),p.usepager){g.pDiv.className="pDiv",g.pDiv.innerHTML='<div class="pDiv2"></div>',$(g.bDiv).after(g.pDiv);var html=' <div class="pGroup"> <div class="pFirst pButton"><span></span></div><div class="pPrev pButton"><span></span></div> </div> <div class="btnseparator"></div> <div class="pGroup"><span class="pcontrol">'+p.pagetext+' <input type="text" size="4" value="1" /> '+p.outof+' <span> 1 </span></span></div> <div class="btnseparator"></div> <div class="pGroup"> <div class="pNext pButton"><span></span></div><div class="pLast pButton"><span></span></div> </div> <div class="btnseparator"></div> <div class="pGroup"> <div class="pReload pButton"><span></span></div> </div> <div class="btnseparator"></div> <div class="pGroup"><span class="pPageStat"></span></div>';if($("div",g.pDiv).html(html),$(".pReload",g.pDiv).click(function(){g.populate()}),$(".pFirst",g.pDiv).click(function(){g.changePage("first")}),$(".pPrev",g.pDiv).click(function(){g.changePage("prev")}),$(".pNext",g.pDiv).click(function(){g.changePage("next")}),$(".pLast",g.pDiv).click(function(){g.changePage("last")}),$(".pcontrol input",g.pDiv).keydown(function(t){13==t.keyCode&&g.changePage("input")}),$.browser.msie&&7>$.browser.version&&$(".pButton",g.pDiv).hover(function(){$(this).addClass("pBtnOver")},function(){$(this).removeClass("pBtnOver")}),p.useRp){for(var opt="",sel="",nx=0;p.rpOptions.length>nx;nx++)sel=p.rp==p.rpOptions[nx]?'selected="selected"':"",opt+="<option value='"+p.rpOptions[nx]+"' "+sel+" >"+p.rpOptions[nx]+"&nbsp;&nbsp;</option>";$(".pDiv2",g.pDiv).prepend("<div class='pGroup'><select name='rp'>"+opt+"</select></div> <div class='btnseparator'></div>"),$("select",g.pDiv).change(function(){p.onRpChange?p.onRpChange(+this.value):(p.newp=1,p.rp=+this.value,g.populate())})}if(p.searchitems){$(".pDiv2",g.pDiv).prepend("<div class='pGroup'> <div class='pSearch pButton'><span></span></div> </div>  <div class='btnseparator'></div>"),$(".pSearch",g.pDiv).click(function(){$(g.sDiv).slideToggle("fast",function(){$(".sDiv:visible input:first",g.gDiv).trigger("focus")})}),g.sDiv.className="sDiv";for(var sitems=p.searchitems,sopt="",sel="",s=0;sitems.length>s;s++)""===p.qtype&&sitems[s].isdefault===!0?(p.qtype=sitems[s].name,sel='selected="selected"'):sel="",sopt+="<option value='"+sitems[s].name+"' "+sel+" >"+sitems[s].display+"&nbsp;&nbsp;</option>";""===p.qtype&&(p.qtype=sitems[0].name),$(g.sDiv).append("<div class='sDiv2'>"+p.findtext+" <input type='text' value='"+p.query+"' size='30' name='q' class='qsbox' /> "+" <select name='qtype'>"+sopt+"</select></div>"),$("input[name=q]",g.sDiv).keydown(function(t){13==t.keyCode&&g.doSearch()}),$("select[name=qtype]",g.sDiv).keydown(function(t){13==t.keyCode&&g.doSearch()}),$("input[value=Clear]",g.sDiv).click(function(){$("input[name=q]",g.sDiv).val(""),p.query="",g.doSearch()}),$(g.bDiv).after(g.sDiv)}}$(g.pDiv,g.sDiv).append("<div style='clear:both'></div>"),p.title&&(g.mDiv.className="mDiv",g.mDiv.innerHTML='<div class="ftitle">'+p.title+"</div>",$(g.gDiv).prepend(g.mDiv),p.showTableToggleBtn&&($(g.mDiv).append('<div class="ptogtitle" title="Minimize/Maximize Table"><span></span></div>'),$("div.ptogtitle",g.mDiv).click(function(){$(g.gDiv).toggleClass("hideBody"),$(this).toggleClass("vsble")}))),g.cdropleft=document.createElement("span"),g.cdropleft.className="cdropleft",g.cdropright=document.createElement("span"),g.cdropright.className="cdropright",g.block.className="gBlock";var gh=$(g.bDiv).height(),gtop=g.bDiv.offsetTop;if($(g.block).css({width:g.bDiv.style.width,height:gh,background:"white",position:"relative",marginBottom:-1*gh,zIndex:1,top:gtop,left:"0px"}),$(g.block).fadeTo(0,p.blockOpacity),$("th",g.hDiv).length){g.nDiv.className="nDiv",g.nDiv.innerHTML="<table cellpadding='0' cellspacing='0'><tbody></tbody></table>",$(g.nDiv).css({marginBottom:-1*gh,display:"none",top:gtop}).noSelect();var cn=0;$("th div",g.hDiv).each(function(){var t=$("th[axis='col"+cn+"']",g.hDiv)[0],e='checked="checked"';"none"==t.style.display&&(e=""),$("tbody",g.nDiv).append('<tr><td class="ndcol1"><input type="checkbox" '+e+' class="togCol" value="'+cn+'" /></td><td class="ndcol2">'+this.innerHTML+"</td></tr>"),cn++}),$.browser.msie&&7>$.browser.version&&$("tr",g.nDiv).hover(function(){$(this).addClass("ndcolover")},function(){$(this).removeClass("ndcolover")}),$("td.ndcol2",g.nDiv).click(function(){return p.minColToggle>=$("input:checked",g.nDiv).length&&$(this).prev().find("input")[0].checked?!1:g.toggleCol($(this).prev().find("input").val())}),$("input.togCol",g.nDiv).click(function(){return p.minColToggle>$("input:checked",g.nDiv).length&&this.checked===!1?!1:($(this).parent().next().trigger("click"),void 0)}),$(g.gDiv).prepend(g.nDiv),$(g.nBtn).addClass("nBtn").html("<div></div>").attr("title","Hide/Show Columns").click(function(){return $(g.nDiv).toggle(),!0}),p.showToggleBtn&&$(g.gDiv).prepend(g.nBtn)}return $(g.iDiv).addClass("iDiv").css({display:"none"}),$(g.bDiv).append(g.iDiv),$(g.bDiv).hover(function(){$(g.nDiv).hide(),$(g.nBtn).hide()},function(){g.multisel&&(g.multisel=!1)}),$(g.gDiv).hover(function(){},function(){$(g.nDiv).hide(),$(g.nBtn).hide()}),$(document).mousemove(function(t){g.dragMove(t)}).mouseup(function(){g.dragEnd()}).hover(function(){},function(){g.dragEnd()}),$.browser.msie&&7>$.browser.version&&($(".hDiv,.bDiv,.mDiv,.pDiv,.vGrip,.tDiv, .sDiv",g.gDiv).css({width:"100%"}),$(g.gDiv).addClass("ie6"),"auto"!=p.width&&$(g.gDiv).addClass("ie6fullwidthbug")),g.rePosDrag(),g.fixHeight(),t.p=p,t.grid=g,p.url&&p.autoload&&g.populate(),t};var docloaded=!1;$(document).ready(function(){docloaded=!0}),$.fn.flexigrid=function(t){return this.each(function(){if(docloaded)$.addFlex(this,t);else{$(this).hide();var e=this;$(document).ready(function(){$.addFlex(e,t)})}})},$.fn.flexReload=function(){return this.each(function(){this.grid&&this.p.url&&this.grid.populate()})},$.fn.flexOptions=function(t){return this.each(function(){this.grid&&$.extend(this.p,t)})},$.fn.flexToggleCol=function(t,e){return this.each(function(){this.grid&&this.grid.toggleCol(t,e)})},$.fn.flexAddData=function(t){return this.each(function(){this.grid&&this.grid.addData(t)})},$.fn.noSelect=function(t){var e=null===t?!0:t;return e?this.each(function(){$.browser.msie||$.browser.safari?$(this).bind("selectstart",function(){return!1}):$.browser.mozilla?($(this).css("MozUserSelect","none"),$("body").trigger("focus")):$.browser.opera?$(this).bind("mousedown",function(){return!1}):$(this).attr("unselectable","on")}):this.each(function(){$.browser.msie||$.browser.safari?$(this).unbind("selectstart"):$.browser.mozilla?$(this).css("MozUserSelect","inherit"):$.browser.opera?$(this).unbind("mousedown"):$(this).removeAttr("unselectable","on")})},$.fn.flexSearch=function(){return this.each(function(){this.grid&&this.p.searchitems&&this.grid.doSearch()})}})(jQuery);

jQuery(document).ready(function($)
{
	W_WIDTH  = screen.width;
	W_HEIGHT = screen.height;

	

	/**
	 * Перетаскивание блоков
	 */
	if($(".column").length > 0)
	{
		$(".column").sortable({
			connectWith: ".portlet-title"
		});
		
		$(".column").disableSelection();
	}
	
	
	
	/* input type file */
	$('.input-file input[type="file"]').live('change', function(){
		$('input[type="text"]', $(this).parent()).val($(this).val());
	});
	
	
	
	/* select */
	if($('.selectbox').length > 0) $('.selectbox').selectbox({animationSpeed: 50}).bind('change', function(){
       	// EVENT
    });
	
	
	
	/* Редактирование телефонов при редактировании
	 * персональных данных
	 */
	$('#addPhone').live('click', function()
	{
		var phones = $(this).closest('.phones');
		var content = $('#newPhone').html();
		var newPhone = '<div class="phone">' + content + '</div>';
		phones.append(newPhone);
		return false;
	});
	$('.del-phone').live('click', function()
	{
		$(this).closest('.phone').remove();
		return false;
	});
	
	
	
	/* Переключение вкладок в блоке с сущностями
	 * 
	 */
	$('.tabs li a').live('click', function()
	{
		var id = $(this).attr('data-id');
		
		$('.tabs li a').removeClass('active');
		$(this).addClass('active');
		
		$('.tab-content').addClass('hidden');
		$('.tab-content[data-id="'+id+'"]').removeClass('hidden');
		
		return false;
	});
	
	
	
	/**
	 * Блок с категориями
	 * Служит для получения кода категории
	 */
	$('.categories .list-categories a').live('click', function()
	{
		var tab = $(this).closest('.tab-content').attr('data-id');
		var cid = $(this).parent().attr('data-cid');
		var pid = $(this).parent().attr('data-pid');
		
		var level  = $(this).closest('.list-categories').attr('data-level');
		var result = '';
		var height = 0;
		
		// Получение объекта списка категорий
		var list = $('#listCategories li[data-pid="' + cid + '"]');
		
		// Получение HTML кода списка категорий
		if(list.length != 0)
		{
			for(var i = 0; i < list.length; i++)
			{
				result += list[i].outerHTML;
			}
		}
		
		// Переключение
		switch(level)
		{
		
		// 2-й уровень
		case '1':
			$('.tab-content[data-id="' + tab + '"] .list-categories[data-level="4"]').html('');
			$('.tab-content[data-id="' + tab + '"] .list-categories[data-level="3"]').html('');
			$('.tab-content[data-id="' + tab + '"] .list-categories[data-level="2"]').html('0');
			
			$('.tab-content[data-id="' + tab + '"]').parent().animate({scrollLeft: 0}, 100);
			$('.tab-content[data-id="' + tab + '"]').parent().css('overflow-x', 'hidden');
			
			$('.tab-content[data-id="' + tab + '"] .list-categories[data-level="2"]').html(result);
		break;
		
		// 3-й уровень
		case '2':
			$('.tab-content[data-id="' + tab + '"] .list-categories[data-level="4"]').html('');
			$('.tab-content[data-id="' + tab + '"] .list-categories[data-level="3"]').html('');
			
			$('.tab-content[data-id="' + tab + '"]').parent().animate({scrollLeft: 0}, 100);
			$('.tab-content[data-id="' + tab + '"]').parent().css('overflow-x', 'hidden');
			
			$('.tab-content[data-id="' + tab + '"] .list-categories[data-level="3"]').html(result);
		break;
		
		// 4-й уровень
		case '3':
			$('.tab-content[data-id="' + tab + '"] .list-categories[data-level="4"]').html('');
			
			$('.tab-content[data-id="' + tab + '"]').parent().animate({scrollLeft: 0}, 100);
			
			if(list.length > 0) 
			{
				$('.tab-content[data-id="' + tab + '"]').parent().css('overflow-x', 'scroll');
				$('.tab-content[data-id="' + tab + '"]').parent().animate({scrollLeft: 1000}, 100);
			}
			else $('.tab-content[data-id="' + tab + '"]').parent().css('overflow-x', 'hidden');
			
			$('.tab-content[data-id="' + tab + '"] .list-categories[data-level="4"]').html(result);
		break;
		
		}
		
		// Вычисление максимальной высоты
		// Возможно улучшить перебрав каждый элемент списка узнав его высоту
		var max_items = 0;
		
		$('.tab-content[data-id="' + tab + '"] .list-categories').each(function()
		{
			if($('li', $(this)).length > max_items) max_items = $('li', $(this)).length;
		});
		
		// Установка максимальной высоты блокам
		$('.tab-content[data-id="' + tab + '"] .list-categories').height(max_items * 35);
		
		// Отображение кода выбранной категории
		$('#codeCategory').html(cid);
		
		// Выделение активной категории на текущем уровне
		$('li a', $(this).closest('.list-categories')).removeClass('active');
		$(this).addClass('active');
		
		// Список выбранных категорий
		var selections = '';
		
		// Построение списка выбранных категорий
		$('.categories .tab-content[data-id="' + tab + '"] .active').each(function()
		{
			selections += $(this).html() + ' » ';
		});
		
		// Отображение списка выбранных категорий
		$('#selectCategories').html(selections.substring(0, selections.length - 2));
		
		return false;
	});
	
	
	
	/* Открытие блока с текстовым полем и автозаполнением
	 * (!) На странице списка фотографий
	 */
	$('a.points[data-type="popup-input"]').live('click', function()
	{
		var id = $(this).attr('data-item');
		var popup = $('.popup-input[data-item="' + id + '"]');
		
		$('.popup-input').addClass('hidden')
		popup.removeClass('hidden');
		
		return false;
	});
	// Закрытие вышеописанного блока
	$('.popup-input .cancel').live('click', function()
	{
		$(this).closest('.popup-input').addClass('hidden');
		return false;
	});
	
	
	
	/* Работа с полями на странице ПРАЙСА или еще гденить
	 * (!) Редактирование ячеек
	 */
	$('.dynamic-coll').live('click', function()
	{

		switch($(this).attr('data-type'))
		{
			
		case "text":
			$('.dynamic-coll .input').each(function()
			{
				swichingField($(this));
			});
			
			$('.title', $(this)).addClass('hidden').next('.input').removeClass('hidden');
			$('input', $('.title', $(this)).addClass('hidden').next('.input')).css({'width': $(this).css('width')});
		break;
		
		case "integer":
			$('.dynamic-coll .input').each(function()
			{
				swichingField($(this));
			});
			
			$('.title', $(this)).addClass('hidden').next('.input').removeClass('hidden');		
		break;
		
		case "select":
			$('.dynamic-coll .input').each(function()
			{
				swichingField($(this));
			});
			
			$('.title', $(this)).addClass('hidden').next('.input').removeClass('hidden');	
		break;
		
		case "popup":
			alert(111);
		break;
		
		}
	});
	
	// Реакция на Enter
	$('.dynamic-coll .input').live('keypress', function(e)
	{
		if(e.keyCode == 13) swichingField($(this));
	});
	
	//$('.kepweb_excel').kepwebExcel({width: 660, height: 150});
	
	/*---------------------------------------------------------------------------------------------------------------------
	 | Вычисление параметров после загрузки страницы (например определить ширину и задать соответствующий стиль)
	 ---------------------------------------------------------------------------------------------------------------------*/
	if($('.scroll').length > 0)
	{
		height = W_HEIGHT - 600 - 50;
		$('.scroll').height(height);
	}
});



/**
 * Переключение типа поля в таблице с ПРАЙСАМИ и или еще гденить
 * @param {Object} obj
 */
function swichingField(obj)
{
	var tag = '';
	
	var value = $(obj.children()[0].tagName, obj).val();
	
	if(value.length > 12) value = value.substring(0, 12) + '...';
	
	obj.addClass('hidden');
	obj.prev('.title').removeClass('hidden').html(value);	
}
