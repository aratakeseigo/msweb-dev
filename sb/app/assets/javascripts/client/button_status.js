function setButtonStatus(statusId, clientId){
    // いったんリンクを非活性にする
    document.getElementsByName('btn-ready-for').forEach(function(btn){
        btn.className = 'btn btn-primary btn-sm disabled';
    });
    // クライアントステータスに応じて、リンクボタンの非活性→活性に変更しhref設定
    (function(statusId, clientId){
        let btnId, url;
        if(statusId == 1){
          btnId = 'btn-company-not-detected';
          url = '/identify_company?id=' + clientId + '&classification=client';
          setButtonEnable(btnId,url)
        }
        //TODO 本来は契約済みだけだが、テストのため、ノーチェック
        // if(statusId == <%= Status::ClientStatus::CONTRACTED.id %>){
          // 審査登録
          btnId = 'btn-ready-for-exam';
          url = '/clients/'+clientId+'/registration_exams';
          setButtonEnable(btnId,url)
          // 保証登録
          btnId = 'btn-ready-for-aguarantee';
          url = '/clients/'+clientId+'/registration_guarantees';
          setButtonEnable(btnId,url)
        // }
        if(statusId == 2 ){
          //CL審査
          btnId = 'btn-ready-for-cl-exam';
          url = '/clients/' + clientId + '/exam';
          setButtonEnable(btnId,url)
        }
        if(statusId == 3 ){
          //CL決裁
          btnId = 'btn-ready-for-cl-approval';
          url = '/clients/' + clientId + '/exam/approve';
          setButtonEnable(btnId,url)
        }
        function setButtonEnable(btnId,url){
          if(url == "#"){
            document.getElementById(btnId).onclick = (function(){
                alert("工事中です。\nもうしばらくお待ち下さい。");
                return false;
              })
          }
          document.getElementById(btnId).className = 'btn btn-primary btn-sm';
          document.getElementById(btnId).href = url;
        }

})(statusId, clientId);
}
