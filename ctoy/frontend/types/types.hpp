// This file contains the types all included in one file

#pragma once

#include <vector>
#include <memory>
#include <frontend/utils/ast.hpp>

#include <frontend/types/qualifiers.hpp>

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

    enum class StorageClassSpecifiers
    {
        NONE = -1,
        STATIC,
        EXTERN,
        AUTO,
        TYPEDEF,
        REGISTER
    };

    class StorageClass : public Terminal
    {
    private:
        std::vector<StorageClassSpecifiers> storage_classes;

    public:
        StorageClass();
        StorageClass(Node *lexeme, StorageClassSpecifiers storage_class);
        std::vector<StorageClassSpecifiers> get_storage_classes() const;
        StorageClass operator+(const StorageClass &other) const;
    };

    class BasicType
    {
    private:
        Type type;
        Rep rep;
        int width;
        std::vector<QualifierSpecifiers> qualifiers;
        std::vector<StorageClassSpecifiers> storage_classes;

    public:
        BasicType(Type type, Rep rep, int width, Qualifier qualifiers = Qualifier(), StorageClass storage_class = StorageClass());
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
        Int(int width, bool is_signed, Qualifier qualifiers = Qualifier(), StorageClass storage_class = StorageClass());
    };

    class Float : public BasicType
    {
    public:
        Float(int width, Qualifier qualifiers = Qualifier(), StorageClass storage_class = StorageClass());
    };

    class Struct : public BasicType
    {
    private:
        std::vector<std::unique_ptr<Identifier>> members;

    public:
        Struct(std::vector<std::unique_ptr<Identifier>> members, Qualifier qualifiers = Qualifier(), StorageClass storage_class = StorageClass());
    };

    class Union : public BasicType
    {
    private:
        std::vector<std::unique_ptr<Identifier>> members;

    public:
        Union(std::vector<std::unique_ptr<Identifier>> members, Qualifier qualifiers = Qualifier(), StorageClass storage_class = StorageClass());
    };

    class Pointer : public BasicType
    {
    private:
        std::unique_ptr<BasicType> base;

    public:
        Pointer(std::unique_ptr<BasicType> base, Qualifier qualifiers = Qualifier(), StorageClass storage_class = StorageClass());
    };

    class Array : public BasicType
    {
    private:
        std::unique_ptr<BasicType> base;
        int dim;

    public:
        Array(std::unique_ptr<BasicType> base, int dim, Qualifier qualifiers = Qualifier(), StorageClass storage_class = StorageClass());
    };

    class Function : public BasicType
    {
    private:
        std::vector<std::unique_ptr<Identifier>> parameters;
        std::unique_ptr<BasicType> return_type;

    public:
        Function(std::vector<std::unique_ptr<Identifier>> parameters, std::unique_ptr<BasicType> return_type, Qualifier qualifiers = Qualifier(), StorageClass storage_class = StorageClass());
    };

    class Typedef : public BasicType
    {
    private:
        std::unique_ptr<BasicType> base;

    public:
        Typedef(std::unique_ptr<BasicType> base, Qualifier qualifiers = Qualifier(), StorageClass storage_class = StorageClass());
    };

    class Enum : public BasicType
    {
    private:
        std::vector<std::unique_ptr<BasicType>> members;

    public:
        Enum(std::vector<std::unique_ptr<BasicType>> members, Qualifier qualifiers = Qualifier(), StorageClass storage_class = StorageClass());
    };

}