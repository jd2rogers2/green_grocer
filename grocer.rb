require 'pry'
def consolidate_cart(cart)
  cart_obj = {}
  cart.each do |item|
    name = item.keys[0]
    if cart_obj[name]
      cart_obj[name][:count] += 1
    else
      cart_obj[name] = item.values[0]
      cart_obj[name][:count] = 1
    end
  end
  cart_obj
end

def apply_coupons(cart, coupons)
  new_cart = {}
  cart.each do |name, attr|
    coupon_matches = coupons.select {|coup| coup[:item] === name}
    coupon_matches.each do |match|
      if match[:num] <= attr[:count]
        attr[:count] -= match[:num]
        if new_cart[name + " W/COUPON"]
          new_cart[name + " W/COUPON"][:count] += match[:num]
        else
          new_cart[name + " W/COUPON"] = {clearance: attr[:clearance], price: match[:cost] / match[:num], count: match[:num]}
        end
      end
    end
    new_cart[name] = attr
  end
  new_cart
end

def apply_clearance(cart)
  cart.each do |name, attr|
    if attr[:clearance]
      attr[:price] = (attr[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  new_cart = apply_clearance(apply_coupons(consolidate_cart(cart), coupons))
  total = 0
  new_cart.each do |name, attr|
    total += attr[:price] * attr[:count]
  end
  total > 100 ? (total * 0.9).round(2) : total
end
