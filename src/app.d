import std.file;
import std.getopt;
import std.path;
import std.stdio;
import std.traits;

import keyvalues;
import vibe.data.json;

struct Docs
{
    Class[] classes;
    Enum[] enums;
    FuncDef[] funcDefs;
    Function[] functions;
    Interface[] interfaces;
    Property[] properties;
    Typedef[] typedefs;
}

struct Interface
{
    Method[] methods;
    string documentation;
    string interfaceName;
    string namespace;
}

struct Class
{
    int flags; //???
    Method[] methods;
    Property[] properties;
    string className;
    string documentation;
    string namespace;
}

struct Method
{
    string declaration;
    string documentation;
}

struct Enum
{
    string documentation;
    string name;
    string namespace;
    Value[] values;
}

struct Value
{
    string documentation;
    string name;
}

struct Function
{
    string declaration;
    string documentation;
    string namespace;
}

struct Property
{
    @Optional string namespace;
    string declaration;
    string documentation;
}

struct Typedef
{
    string documentation;
    string name;
    string namespace;
    string type;
}

struct FuncDef
{
    string documentation;
    string name;
    string namespace;
}

int main(string[] args)
{
    if(args.length != 2)
    {
        stderr.writefln("Usage: %s docs.txt", args[0].baseName);
        
        return 1;
    }
    
    auto inFile = args[1];
    
    if(!inFile.exists)
    {
        stderr.writefln("%s does not exist", inFile);
        
        return 1;
    }
    
    auto outFile = inFile.withExtension(".json");
    
    inFile
        .readText
        .parseKeyValues["Angelscript Documentation"][0]
        .deserializeKeyValues!Docs
        .serializeToJsonString
        .Identity!(json => std.file.write(outFile, json))
    ;
    
    return 0;
}
