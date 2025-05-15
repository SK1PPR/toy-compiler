#pragma once

#include <vector>
#include <memory>

namespace frontend
{

    enum class Type
    {
        INVALID = -1,
        VOID = 0,
        INT,
        FLOAT,
        STRUCT,
        UNION,
        ENUM,
        POINTER,
        FUNCTION,
        ARRAY,
        TYPEDEF
    };

    enum class Rep
    {
        NONE = -1,
        SIGNED,
        UNSIGNED,
        FLOAT
    };

    enum class Qualifier
    {
        NONE = -1,
        CONST,
        VOLATILE
    };

    enum class StorageClass
    {
        NONE = -1,
        STATIC,
        EXTERN,
        AUTO,
        TYPEDEF,
        REGISTER
    };

    class BasicType
    {
    private:
        Type type;
        Rep rep;
        int width;
        std::vector<Qualifier> qualifiers;
        std::vector<StorageClass> storage_classes;

    public:
        BasicType(Type type, Rep rep, int width, std::vector<Qualifier> qualifiers = {}, std::vector<StorageClass> storage_classes = {});
        void add_qualifier(Qualifier qualifier);
        void add_storage_class(StorageClass storage_class);
    };

    class Identifier
    {
    private:
        std::string name;
        std::unique_ptr<BasicType> type;

    public:
        Identifier(std::string name, std::unique_ptr<BasicType> type);
    };

    class Void : public BasicType
    {
    public:
        Void();
    };

    class Int : public BasicType
    {
    public:
        Int(int width, bool is_signed, std::vector<Qualifier> qualifiers = {}, std::vector<StorageClass> storage_classes = {});
    };

    class Float : public BasicType
    {
    public:
        Float(int width, std::vector<Qualifier> qualifiers = {}, std::vector<StorageClass> storage_classes = {});
    };

    class Struct : public BasicType
    {
    private:
        std::vector<std::unique_ptr<Identifier>> members;

    public:
        Struct(std::vector<std::unique_ptr<Identifier>> members);
    };

    class Union : public BasicType
    {
    private:
        std::vector<std::unique_ptr<Identifier>> members;

    public:
        Union(std::vector<std::unique_ptr<Identifier>> members);
    };

    class Pointer : public BasicType
    {
    private:
        std::unique_ptr<BasicType> base;

    public:
        Pointer(std::unique_ptr<BasicType> base);
    };

    class Array : public BasicType
    {
    private:
        std::unique_ptr<BasicType> base;
        int dim;

    public:
        Array(std::unique_ptr<BasicType> base, int dim);
    };

    class Function : public BasicType
    {
    private:
        std::vector<std::unique_ptr<Identifier>> parameters;
        std::unique_ptr<BasicType> return_type;

    public:
        Function(std::vector<std::unique_ptr<Identifier>> parameters, std::unique_ptr<BasicType> return_type);
    };

    class Typedef : public BasicType
    {
    private:
        std::unique_ptr<BasicType> base;

    public:
        Typedef(std::unique_ptr<BasicType> base);
    };

    // TODO: Implement enum
    class Enum : public BasicType
    {
    private:
        std::vector<std::unique_ptr<BasicType>> members;

    public:
        Enum(std::vector<std::unique_ptr<BasicType>> members);
    };

}