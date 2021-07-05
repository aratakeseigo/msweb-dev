function setButtonStatus(statusId, isSetGuaranteeClilentEntityId, isSetGuaranteeCustomerEntityId, guaranteeExamId){
    // いったんリンクを非活性にする
    document.getElementsByName('btn-ready-for').forEach(function(btn){
        btn.className = 'btn btn-primary btn-sm disabled';
    });
    // クライアントステータスと、リンクボタンの非活性→活性に変更しhref設定
    (function(statusId, isSetGuaranteeClilentEntityId, isSetGuaranteeCustomerEntityId, guaranteeExamId){
        let btnId, url;
        // 保証元を特定
        if(statusId == 1 && !isSetGuaranteeClilentEntityId){
          btnId = 'btn-sb-guarantee-client';
          url = '/identify_company?id=' + guaranteeExamId + '&classification=guarantee_client';
          setButtonEnable(btnId,url)
        }
        // 保証先を特定
        if(statusId == 1 && !isSetGuaranteeCustomerEntityId){
          btnId = 'btn-sb-guarantee-customer';
          url = '/identify_company?id=' + guaranteeExamId + '&classification=guarantee_customer';
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

    })(statusId, isSetGuaranteeClilentEntityId, isSetGuaranteeCustomerEntityId, guaranteeExamId);
}
