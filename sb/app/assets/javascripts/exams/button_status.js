function setButtonStatus(statusId, guaranteeClilentEntityId, guaranteeCustomerEntityId, guaranteeExamId){
    // いったんリンクを非活性にする
    document.getElementsByName('btn-ready-for').forEach(function(btn){
        btn.className = 'btn btn-primary btn-sm disabled';
    });
    // クライアントステータスと、リンクボタンの非活性→活性に変更しhref設定
    (function(statusId, guaranteeClilentEntityId, guaranteeCustomerEntityId, guaranteeExamId){
        let btnId, url;
        // 保証元を特定
        if(statusId == 1 && !Number.isInteger(guaranteeClilentEntityId)){
          btnId = 'btn-sb-guarantee-client';
          url = '/identify_company?id=' + guaranteeExamId + '&classification=2';
          setButtonEnable(btnId,url)
        }
        // 保証先を特定
        if(statusId == 1 && !Number.isInteger(guaranteeCustomerEntityId)){
          btnId = 'btn-sb-guarantee-customer';
          url = '/identify_company?id=' + guaranteeExamId + '&classification=3';
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

    })(statusId, guaranteeClilentEntityId, guaranteeCustomerEntityId, guaranteeExamId);
}
