

function setButtonStatus(statusId, clientId){
    // いったんリンクを非活性にする
    document.getElementsByName('btn-ready_for').forEach(function(btn){
        btn.className = 'btn btn-primary btn-sm disabled';
    });
    // クライアントステータスに応じて、リンクボタンの非活性→活性に変更しhref設定
    (function(statusId, clientId){
        let btnId, url;
        switch(statusId){
            case 1:{
                btnId = 'btn-company_not_detected';
                url = '/identify_company?id=' + clientId + '&classification=1';
                break;
            }
            case 2:{ 
                btnId = 'btn-ready_for_exam';
                url = '/審査登録';
                break;
            }
            case 3:{
                btnId = 'btn-ready_for_aguarantee';
                url = '/保証登録';
                break;
            }
            case 4:{
                btnId = 'btn-ready_for_cl_exam';
                url = '/CL審査';
                break;
            }
            case 5:{
                btnId = 'btn-ready_for_cl_approval';
                url = '/CL決裁';
                break;
            }
            default :{
                break;
            }
        }
        document.getElementById(btnId).className = 'btn btn-primary btn-sm';
        document.getElementById(btnId).href = url;
    })(statusId, clientId);
}