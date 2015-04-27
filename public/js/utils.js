function getUrlParam(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return decodeURIComponent(r[2]);
    return null;
}
function avoid() {
    void(0);
}
function jsonStringIn(jsonUserInfo) {

    var jsonString = "{" + jsonUserInfo + "}";
    var json = $.parseJSON(jsonString)
    return json;
}

//  show_invest页面
function html_show_list(name, uri) {
    var id = getUrlParam(name);
    jsonUserInfo = "\"" + name + "\":\"" + id + "\"";
    da = jsonStringIn(jsonUserInfo);
    $.ajax({
        url: uri,
        data: da,
        dataType: 'json',
        success: function (data) {
//

            var loan = data.loan;
            // 标的总额
            var amount = (Number(loan.amount) / 10000).toFixed(1) + '万';
            // 年利率
            var interest = loan.interest + '%';
            // 还款期限
            var months = loan.months + '个月';
            // 可得收益
            var earnings_tmp = Number(data.earnings_tmp).toFixed(2);
            // 还款方式
//                var repay_style = loan.repay_style;
            // 进度
            var progress = (1 - loan.available_amount / loan.amount).toFixed(3);
            $('#percent').html(progress*100 + '%');
            showProgress('divProgress', progress);
            // 还需金额
            var balance = loan.available_amount;
            // 信用等级
            var credit_level = (loan.credit_level).toUpperCase();
            // 账户现金
            var cash_account = data.cash_account;
            $('.yuanyin').text(loan.title);
            $('.loan_type').text(loan.title);
            $('.available_amount').text(Number(loan.available_amount) + '元');
            $('.loan_total_amount').text(amount);
            $('.loan_invest').text(interest);
            $('.repayment_period').text(months);
            $('.earnings_tmp').text(earnings_tmp);
            $('.repayment_methods').text(data.repayment_methods);
            if (loan.loan_state_id == data.loan_state_id) {
                str = "<button id='toubiao' style='display: none;' data-toggle='modal'  role='button' class='btn btn-primary' onclick='bind_Click();'>我要投标</button>";
            } else {
                str = '<button class="btn">' + data.state_name + '</button>';
            }
            $(".rightblockfa").append(str);
            if (data.current_user == 1) {
                (Number(loan.amount) / 10000).toFixed(0) + '万'
                $('.loan_amount').text(loan.amount);
                $('.balance').text(balance);
                $('.cash_account').text(cash_account);
                $('#bid_loan_id').val(loan.id);
                $("#toubiao").show();
            } else {
                $('.text-center').show();
                $('.box-no-padding').html(data.must_be_login).attr('disabled', 'disabled');
            }
        }
    });
}
//  show_debts页面
function html_show_debts(name, uri) {
    var id = getUrlParam(name);
    jsonUserInfo = "\"" + name + "\":\"" + id + "\"";
    da = jsonStringIn(jsonUserInfo);
    $.ajax({
        url: uri,
        data: da,
        dataType: 'json',
        success: function (data) {
//

            var loan = data.loan;
            // 标的总额
            var amount = (Number(loan.amount) / 10000).toFixed(1) + '万';
            // 年利率
            var interest = loan.interest + '%';
            // 还款期限
            var months = loan.months + '个月';
            // 可得收益
            var earnings_tmp = Number(data.earnings_tmp).toFixed(2);
            // 还款方式
//                var repay_style = loan.repay_style;
            // 进度
            var progress = loan.progress;
            // 还需金额
            var balance = loan.available_amount;
            // 信用等级
            var credit_level = (loan.credit_level).toUpperCase();
            // 账户现金
            var cash_account = data.cash_account;
            // 借款编号
            // var loan_code = data.loan_code;
            // 转让金额(元)
            var icon_jpy =( Number(data.bid.for_sale_amount)).toFixed(2);
            // 剩余期限(月)
            var subtotal = data.bid.for_sale_month || '';
            // 年利率
            var interest_year = data.interest_year+'%';


//            $('.loan_amount').text(loan_amount);
            $('.interest_year').text(interest_year);
            $('.icon_jpy').text(icon_jpy);
            $('.yuanyin').text(loan.title);
            $('.subtotal').text(subtotal);
            // $('.loan_code').text(loan_code);
            $('.loan_type').text(loan.title);
            $('.available_amount').text(Number(loan.available_amount) + '元');
            $('.loan_total_amount').text(amount);
            $('.loan_invest').text(interest);
            $('.repayment_period').text(months);
            $('.earnings_tmp').text(earnings_tmp);
            $('.repayment_methods').text(data.repayment_methods);
            if (loan.with_mortgage )
            var str = '';
            str = "<button id='toubiao' style='display: none;' data-toggle='modal'  role='button' class='btn btn-primary' onclick='bind_Click();'>我要投标</button>";
            if (data.current_user == 1 ) {
                if (data.bid_user_not_cur_user == 0){
                    $('.modal-bodys').show();

                }else{
                    $(".rightblockfa").append(str);
                    $('.loan_amount').text(icon_jpy);
                    $('.balance').text(balance);
                    $('.cash_account').text(cash_account);
                    $('#bid_loan_id').val(loan.id);
                    $('#bid_from_bid_id').val(data.child_bid);
                    $("#toubiao").show();
                    getDebtForm();
                }
            } else {
                $('.sigup_sigin').show();
                $('.box-no-padding').html(data.must_be_login).attr('disabled', 'disabled');
            }
        }
    });
}

//
function getDebtForm(){
    $.ajax({
        url: '/debts/new?id='+getUrlParam('id'),
        success: function (data) {
            $('.modal-dialog').html(data);
        }
    });
}
// 页面中的头与尾的实现
$.ajax({
    url: "/home/basic_info_json",
    dataType: 'json',
    success: function (data) {
        $('title').text(data.company_name);
        $('.phone400').text(data.phone400);
        $('.qq_group').text(data.qq_group);
        $('#serve_time').text(' 服务时间：' + data.serve_time);
        $('.serve_time').text(' 服务时间：' + data.serve_time);
        if (data.username.length > 0) {
            $('#username').text(data.username);
            $('#hello').show();
        } else {
            $('.sign').show();
        }
    }
});

function bind_Click() {
        $('.modal-dialog').toggle()
};

function showProgress(id, percent){
    $('#'+id).circleProgress({
        value: percent,
        size: 150,
        fill: {
            gradient: ['#4cadda', "#4cadda"]
        }
    });
}
$(function(){
    if(getUrlParam('errors')){
        alert(getUrlParam('errors'));
    }
    if(getUrlParam('notice')){
        alert(getUrlParam('notice'));
    }
})