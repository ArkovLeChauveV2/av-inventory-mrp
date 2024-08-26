local color_green, color_red = Color(0, 255, 0), Color(255, 0, 0)

if Arkonfig.Inventory.UseMySQLoo then
    if !file.Exists("mangarp/av-inv-mrp-credentials.json", "DATA") then
        file.CreateDir("mangarp")
        file.Write("mangarp/av-inv-mrp-credentials.json", util.TableToJSON({
            user = "",
            database = "",
            host = "",
            password = "",
            port = "3306"
        }))

        MsgC(color_red, "[av-inv-mrp] Empty database credentials.\n")
        MsgC(color_red, "[av-inv-mrp] Goto mangarp/av-inv-mrp-credentials.json and fill the credentials.\n")
        MsgC(color_red, "[av-inv-mrp] The addon will use sqlite until you'll fix that.\n")

        Arkonfig.Inventory.UseMySQLoo = false
        hook.Run("DatabaseInitialized")
        
        goto passMySQLOOSetup // goto will pass the sql setup that is above
    end

    require("mysqloo")

    if !mysqloo then
        MsgC(color_red, "[av-inv-mrp] MySQLoo isn't well setuped.\n")
        hook.Run("DatabaseInitialized")

        goto passMySQLOOSetup // goto will pass the sql setup that is above
    end

    local tSqlCredentials = util.JSONToTable(file.Read("mangarp/av-inv-mrp-credentials.json", "DATA") || {})

    if !tSqlCredentials then
        MsgC(color_red, "[av-inv-mrp] MySQLoo credentials aren't setupped.\n")
        MsgC(color_red, "[av-inv-mrp] Goto mangarp/av-inv-mrp-credentials.json and fill the credentials.\n")
        MsgC(color_red, "[av-inv-mrp] The addon will use sqlite until you'll fix that.\n")

        hook.Run("DatabaseInitialized")

        goto passMySQLOOSetup // goto will pass the sql setup that is above
    end
    
    Arkonfig.Inventory.Database = mysqloo.connect(
        tSqlCredentials["host"] || "",
        tSqlCredentials["user"] || "",
        tSqlCredentials["password"] || "",
        tSqlCredentials["database"] || "",
        tSqlCredentials["port"] || ""
    )
    
    function Arkonfig.Inventory.Database:onConnectionFailed(err)
        MsgC(color_red, "[av-inv-mrp] Database connexion failed:\n")
        MsgC(color_red, err .. "\n")
        MsgC(color_red, "[av-inv-mrp] The addon will use sqlite until you'll fix that.\n")

        Arkonfig.Inventory.UseMySQLoo = false
        hook.Run("DatabaseInitialized")
    end
    
    function Arkonfig.Inventory.Database:onConnected(db)
        MsgC(color_green, "[av-inv-mrp] Database successfully connected.\n")
        hook.Run("DatabaseInitialized")
    end

    Arkonfig.Inventory.Database:connect()
end

::passMySQLOOSetup::
/*
    local secureStr(sText)

    Escape the inputed strings to prevent SQL Injection.

    @param String sText - The string to escape.

    @return String - The escaped string.
*/
local function secureStr(sText)
    return Arkonfig.Inventory.UseMySQLoo && "'" .. Arkonfig.Inventory.Database:escape(sText) .. "'" || SQLStr(sText)
end

/*
    Arkonfig.Inventory:Query(query, ...)

    Launch a sql query to database.
    Compatible with sqlite and mysqloo.
    Put Arkonfig.Inventory.UseMySQLoo to true to use mysqloo.

    @param String sQuery - The SQL query to execute.
    @param varargs Fields - The fields to integrate into the query.
    @param function(tData) callback - (optional) The callback function to execute after the request.
*/
function Arkonfig.Inventory:Query(sQuery, ...)
    local fCallback
    
    local tArgs = {...}

    // Retrieve the callback function, the callback function should always be the last argument.
    if isfunction(tArgs[#tArgs]) then
        fCallback = tArgs[#tArgs]
        tArgs[#tArgs] = nil
    end

    // String escaping all the arguments to prevent SQL injections
    for k, v in ipairs(tArgs) do
        tArgs[k] = escape(v)
    end

    // Putting arguments into the query
    sQuery = sQuery:format(unpack(tArgs))
    
    local tQuery = Arkonfig.Inventory.UseMySQLoo && Arkonfig.Inventory.Database:query(sQuery) || sql.Query(sQuery)


    if Arkonfig.Inventory.UseMySQLoo then
        function tQuery.onError(_, qr)
            MsgC(color_red, "[av-inv-mrp] An error has occured !", query, qr, "\n")
        end

        function tQuery.onSuccess(_, data)
            if !callback then return end

            data = data or {}
            data["inserted_id"] = tQuery:lastInsert()

            callback(data)
        end

        tQuery:start()
    else
        if tQuery == false then
            print("[av-inv-mrp] SQLite Error: "..sql.LastError())
            return 
        end

        if !callback then return end
        callback(tQuery || {})
    end
end