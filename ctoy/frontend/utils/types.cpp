#include <frontend/utils/types.hpp>

namespace frontend
{
    BasicType::BasicType(Type type, Rep rep, int width, std::vector<Qualifier> qualifiers, std::vector<StorageClass> storage_classes)
        : type(type), rep(rep), width(width), qualifiers(qualifiers), storage_classes(storage_classes) {}

    void BasicType::add_qualifier(Qualifier qualifier) {
        qualifiers.push_back(qualifier);
    }

    void BasicType::add_storage_class(StorageClass storage_class) {
        storage_classes.push_back(storage_class);
    }

    Identifier::Identifier(std::string name, std::unique_ptr<BasicType> type)
        : name(name), type(std::move(type)) {}

    Void::Void()
        : BasicType(Type::VOID, Rep::NONE, 0) {}

    Int::Int(int width, bool is_signed, std::vector<Qualifier> qualifiers, std::vector<StorageClass> storage_classes)
        : BasicType(Type::INT, is_signed ? Rep::SIGNED : Rep::UNSIGNED, width, qualifiers, storage_classes) {}

    Float::Float(int width, std::vector<Qualifier> qualifiers, std::vector<StorageClass> storage_classes)
        : BasicType(Type::FLOAT, Rep::FLOAT, width, qualifiers, storage_classes) {}

    Struct::Struct(std::vector<std::unique_ptr<Identifier>> members)
        : BasicType(Type::STRUCT, Rep::NONE, 0, {}, {}), members(std::move(members)) {}

    Union::Union(std::vector<std::unique_ptr<Identifier>> members)
        : BasicType(Type::UNION, Rep::NONE, 0, {}, {}), members(std::move(members)) {}

    Pointer::Pointer(std::unique_ptr<BasicType> base)
        : BasicType(Type::POINTER, Rep::NONE, 0, {}, {}), base(std::move(base)) {}

    Array::Array(std::unique_ptr<BasicType> base, int dim)
        : BasicType(Type::ARRAY, Rep::NONE, 0, {}, {}), base(std::move(base)), dim(dim) {}

    Function::Function(std::vector<std::unique_ptr<Identifier>> parameters, std::unique_ptr<BasicType> return_type)
        : BasicType(Type::FUNCTION, Rep::NONE, 0, {}, {}), parameters(std::move(parameters)), return_type(std::move(return_type)) {}

    Typedef::Typedef(std::unique_ptr<BasicType> base)
        : BasicType(Type::TYPEDEF, Rep::NONE, 0, {}, {}), base(std::move(base)) {}

    Enum::Enum(std::vector<std::unique_ptr<BasicType>> members)
        : BasicType(Type::ENUM, Rep::NONE, 0, {}, {}), members(std::move(members)) {}
    
}