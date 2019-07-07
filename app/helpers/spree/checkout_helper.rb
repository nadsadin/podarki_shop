module Spree::CheckoutHelper
  def sw_checkout_progress
    states = @order.checkout_steps
    icon_classes = {"address" => 'sw-icon ion ion-md-map', "delivery" => "sw-icon ion ion-ios-airplane", "payment" => "sw-icon ion ion-md-card", "complete" => "sw-icon ion ion-md-checkmark-circle-outline"}
    items = states.each_with_index.map do |state, i|
      text = Spree.t("order_state.#{state}").titleize
      item_icon = content_tag('span','', class: icon_classes[state])
      item_done_icon = content_tag('span','', class: 'sw-done-icon ion ion-md-checkmark')
      item_inner = content_tag('span', raw(item_done_icon+item_icon+text), class: "mb-4 nav-link text-primary")
      css_classes = ['nav-item']
      current_index = states.index(@order.state)
      state_index = states.index(state)

      if state_index < current_index
        css_classes << 'done'
        item_inner = link_to raw(item_done_icon+item_icon+text), checkout_state_path(state), class: "mb-4 nav-link text-primary"
      end

      css_classes << 'active' if state == @order.state

      content_tag('li', raw(item_inner), class: css_classes.join(' '))
    end
    list = content_tag('ul', raw(items.join("\n")), class: 'px-4 px-lg-5 pt-4 nav nav-tabs step-anchor', id: "checkout-step-#{@order.state}")
    content_tag('div', raw(list), class: "sw-main sw-theme-default")
  end
end