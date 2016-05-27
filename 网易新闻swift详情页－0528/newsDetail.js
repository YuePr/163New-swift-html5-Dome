window.onload = function(){
    // 拿到所有的图像标签
    var allImg = document.getElementsByTagName('img');
    // 遍历
    for(var i=0; i<allImg.length; i++){
       // 拿到单个图像标签
        var img = allImg[i];
        img.id = i;
       // 监听点击
        img.onclick = function(){
//            alert('点击了第' + this.id + '张');
            // window
//            window.location.href = 'http://www.baidu.com';
            
            // 发送特殊的请求
            window.location.href = 'wangyi://openCamera'
            
        }
    }
    
    
    // 往页尾插入图片
    var img = document.createElement('img');
    img.src = "http://img2.cache.netease.com/f2e/news/res/channel_logo/news.png";
    img.style.width = "120px";
//    img.style.height = 
    document.body.appendChild(img);
    
    // 删除最后一段文字
    var p = document.getElementsByTagName('p');
    p[p.length-1].remove();
}