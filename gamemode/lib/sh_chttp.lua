module("chttp", package.seeall)

function Get(url, headers)
	local cr = coroutine.running()

	if not cr then
		return
	end

	local function success(body, length, head, status)
		coroutine.resume(cr, true, body, head, status)
	end

	local function fail(err)
		coroutine.resume(cr, false, err)
	end

	http.Fetch(url, success, fail, headers)

	return coroutine.yield()
end