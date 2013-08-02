$(document).ready(function(){
  friend_attack();
  friend_special();
  friend_defense();
  enemy_turn();
});

function friend_attack() {
   $(document).on("click", "#attack", function() {
    var name = $(this).attr('rubymon');
      alert("Your "+name+" use tackle")
      $.ajax({
      type: 'POST',
      url: '/attack'
    }).done(function(msg){
      $("div#battle").replaceWith(msg);
    });
    return false;
  });
}

function friend_special() {
   $(document).on("click", "#special", function() {
    var name = $(this).attr('rubymon');
    var smove = $(this).attr('smove');
      alert("Your "+name+" use "+smove)
      $.ajax({
      type: 'POST',
      url: '/special'
    }).done(function(msg){
      $("div#battle").replaceWith(msg);
    });
    return false;
  });
}

function friend_defense() {
   $(document).on("click", "#defense", function() {
    var name = $(this).attr('rubymon');
      alert("Your "+name+"use defense")
      $.ajax({
      type: 'POST',
      url: '/defense'
    }).done(function(msg){
      $("div#battle").replaceWith(msg);
    });
    return false;
  });
}

function enemy_turn() {
   $(document).on("click", "#enemy_btn", function() {
    
      $.ajax({
      type: 'POST',
      url: '/enemy_turn'
    }).done(function(msg){
      $("div#battle").replaceWith(msg);
    });
    return false;
  });
}