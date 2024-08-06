class_name Z_SetterUtil extends RefCounted

static func setter(o:Object,k:StringName,v:Variant,s:Signal) -> bool:
	if not o: return false
	var val = o.get(k)
	if val == v: return false
	o.set(k,v) 
	if s: s.emit(v,val)
	return true

static func setter_float_relative(o:Object,k:StringName,delta:Variant,s:Signal) -> bool:
	if not o: return false
	var old_val = o.get(k)
	if is_zero_approx(delta): return false
	var new_val = old_val + delta
	o.set(k, new_val) 
	if s: s.emit(new_val,old_val)
	return true

static func setter_float(o:Object,k:StringName,v:Variant,s:Signal) -> bool:
	if not o: return false
	var val = o.get(k)
	if is_equal_approx(val, v): return false
	o.set(k,v) 
	if s: s.emit(v,val)
	return true

