// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


function add_new_todo_element(todo){
      var todo_row = $(document.createElement("tr"));
      todo_row.addClass("new_todo_item");
      var title = $(document.createElement("td"));
      title.html(todo.title);
      var expected_duration = $(document.createElement("td"));
      expected_duration.html(""+todo.expected_duration);
      var due_date = $(document.createElement("td"));
      due_date.html(todo.due_date);
      var is_finished = $(document.createElement("td"));
      var is_finished_checkbox = $("<input type='checkbox'/>");
      //is_finished_checkbox.setAttribute("type", "checkbox");
      is_finished_checkbox.bind("click", todo,
            function(){
                update_todo_is_finished(arguments[0].data.todo_list_id,
                                        arguments[0].data.todo_id,
                                        arguments[0].target,
                                        arguments[0].target.checked);
            } );
      is_finished.append(is_finished_checkbox);
      var delete_link_col = $('<td/>');
      var delete_link = $('<a href="#">Delete</a>');
      delete_link.bind("click", todo,
            function(){
                var d = arguments[0].data;
                remove_todo_item_from_list(arguments[0].target,
                                           "/todo_lists/"+d.todo_list_id+"/todos/"+d.todo_id+".js");
            });
      delete_link_col.append(delete_link);

      todo_row.append(title);
      todo_row.append(expected_duration);
      todo_row.append(due_date);
      todo_row.append(is_finished);
      todo_row.append(delete_link_col);

      $("#todos_table").append(todo_row);      
}

function update_todo_is_finished(todo_list_id,todo_id,item, checked){
	$.ajax({
	   type: "PUT",
       url: "/todo_lists/"+todo_list_id+"/todos/" +todo_id+".js" ,
       data: {
       		todo: {is_finished: checked}
       },
       success: function(response, status){
           var table_parent_row = $(item).parent().parent();
           if (checked){
               $(item).addClass("todo_finished");
               table_parent_row.addClass("todo_finished");
           }
           else{
                $(item).removeClass("todo_finished");
    	      	table_parent_row.removeClass("todo_finished");
           }
	    }
    });
}

function remove_todo_item_from_list(delete_link,url){
	$.ajax({
	   type: "DELETE",
       url: url,
//       data: {
//       		todo: {is_finished: checked}
//       },
       success: function(response, status){
           var table_parent_row = $(delete_link).parent().parent();
           table_parent_row.remove();
           $('#status').html(response);
           
       },
       error: function(response, status){
           //TODO: make me highlight nicely :)
           //var table_parent_row = $(delete_link).parent().parent().highlight();;
           $('#status').html(response.responseText);
       }
    });
}

