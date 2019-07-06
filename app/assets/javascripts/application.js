// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery3
//= require activestorage
//= require_tree .

$(function(){


  // ヘッダーメニューの表示・非表示
  $(".show_header_menu").click(function(){
    $("#header_menu").slideToggle();
    if($(this).hasClass("hide")){
      $(this).html("<i class='fas fa-bars'></i>");
      $(this).removeClass("hide");
      document.removeEventListener('touchmove', handleTouchMove, { passive: false }); //スクロール禁止を解除
      $("#back").hide();
    } else {
      $(this).html("<i class='fas fa-times'></i>");
      $(this).addClass("hide");
      document.addEventListener('touchmove', handleTouchMove, { passive: false }); //スクロール禁止
      $("#back").show();
    }
  });

  $("#back").click(function(){
    $(".show_header_menu").html("<i class='fas fa-bars'></i>");
    $(".show_header_menu").removeClass("hide");
    $("#header_menu").slideUp();
    document.removeEventListener('touchmove', handleTouchMove, { passive: false }); //スクロール禁止を解除
    $("#back").hide();
  });

  function handleTouchMove(event) {
    event.preventDefault();
  }


  // successメッセージの表示からフェードアウトまで
  $("#success").animate({right: 0}, 1000);
  $("#success").delay(1500).fadeOut(1000);

  // noticeメッセージの非表示
  $("#notice_back").on("click", function(){
    $("#notice").fadeOut();
    $(this).fadeOut();
  });

  // エラーメッセージ
  $("#alert #close").click(function (){
    $("#alert").slideUp();
  });


  //ユーザー編集画面でのパスワード変更の表示・非表示
  $("#password_change_btn").click(function(){
    $("#password_change_field").slideToggle();
    if($(this).hasClass("hide")){
      $(this).html("パスワード変更 <i class='fas fa-angle-down'></i>");
      $(this).removeClass("hide");
      $("#password").val("");
      $("#password_confirmation").val("");
    } else {
      $(this).html("キャンセル <i class='fas fa-angle-up'></i>");
      $(this).addClass("hide");
    }
  });


  // carrierwave(画像アップローダー)のプレビュー表示
  $(document).on("change", ":file", function() {
    var input = $(this);
    var files = !!this.files ? this.files : [];
    if (!files.length || !window.FileReader) return; // ファイルが選択されていない、ファイルリーダーがサポートされていない場合はリターン
    if (/^image/.test( files[0].type)){ // 画像ファイルだけ許可
      var reader = new FileReader(); // ファイルリーダーのインスタンスを作成
      reader.readAsDataURL(files[0]); // 画像を読み込む
      reader.onloadend = function(){ // divの背景画像として読み込んだ画像をセット
        if (!input.hasClass("code_image")) {
          // 普通の画像の場合
          input.parents(".field").find(".imagePreview").css("height", "300px");
          input.parents(".field").find(".imagePreview").css("background-image", "url("+this.result+")");
          input.parents(".field").find(".imagePreview").children("img").css("display", "none");
          input.parents(".field").find(".remove_label").show();
          input.parents(".field").find(".remove_image_btn").prop("checked", false);
        } else {
          // codeフィールドの画像の場合
          input.parents(".nested-fields").find(".imagePreview").css("height", "300px");
          input.parents(".nested-fields").find(".imagePreview").css("background-image", "url("+this.result+")");
          input.parents(".nested-fields").find(".imagePreview").children("img").css("display", "none");
          input.parents(".code_image_btn").css({"background":"#595857", "color":"white"});
          input.parents(".nested-fields").find(".remove_label").show();
          input.parents(".nested-fields").find(".remove_image_btn").prop("checked", false);
        }
      }
    }
  });

  // 画像削除ボタンをクリックしたとき、プレビュー画像を非表示にする。
  $(document).on('change','.remove_image_btn',function(){
    if ($(this).prop('checked')) {
      if (!$(this).hasClass("code_image")) {
        // 普通の画像の場合
        $(this).parents(".field").find(".imagePreview").css("height", "0");
        $(this).parents(".remove_label").hide();
      } else {
        // codeフィールドの画像の場合
        $(this).parents(".field").find(".imagePreview").css("height", "0");
        $(this).parents(".remove_label").hide();
        $(this).parents(".nested-fields").find(".code_image_btn").css({"background":"white", "color":"#595857", "border":"0.5px solid #595857"});
      }
    }
  });


});


