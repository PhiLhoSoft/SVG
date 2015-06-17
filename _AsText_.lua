--# From: kleiser@online.no (Jon Kleiser)

function AsText(obj)
   -- Returns a textual representation of "any" Lua object,
   -- incl. tables (and nested tables).
   -- Functions are not decompiled (of course).
   -- Try: print(asText({{"a", "b"}; c=3}))

   visitRef = {}
   visitRef.n = 0

   asTxRecur = function(obj, asIndex)
      if type(obj) == "table" then
         if visitRef[obj] then
            return "@"..visitRef[obj]
         end
         visitRef.n = visitRef.n +1
         visitRef[obj] = visitRef.n

         local begBrac, endBrac
         if asIndex then
            begBrac, endBrac = "[{", "}]"
         else
            begBrac, endBrac = "{", "}"
         end
         local t = begBrac
         local k, v = nil, nil
         repeat
            k, v = next(obj, k)
            if k ~= nil then
               if t > begBrac then
                  t = t..", "
               end
               t = t..asTxRecur(k, 1).."="..asTxRecur(v)
            end
         until k == nil
         return t..endBrac
      else
         if asIndex then
            -- we're on the left side of an "="
            if type(obj) == "string" then
               return obj
            else
               return "["..obj.."]"
            end
         else
            -- we're on the right side of an "="
            if type(obj) == "string" then
               return '"'..obj..'"'
            else
               return tostring(obj)
            end
         end
      end
   end -- asTxRecur

   return asTxRecur(obj)
end -- asText
