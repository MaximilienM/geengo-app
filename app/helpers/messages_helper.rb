# encoding : utf-8

module MessagesHelper
  
  def comment_label(message)
    
    return unless controller.is_a?(SportCommunitiesController) && message.commentable
    
    case message.commentable
    when Event
      text = "évènement"
      method = :name
    when Infrastructure
      text = "où pratiquer"
      method = :display_name
    end
    
    content_tag(:span,
      :class => "label",
      :rel => "twipsy",
      "data-original-title" => message.commentable.send(method),
      "data-placement" => "above"
    ) do
      link_to text, message.commentable
    end
    
  end
  
end
