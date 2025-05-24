#include <frontend/types/types.hpp>

namespace frontend
{

    BasicType::BasicType(Type type, Rep rep, int width, Qualifier qualifiers, StorageClass storage_class)
        : type(type), rep(rep), width(width), qualifiers(qualifiers.get_qualifiers()), storage_classes(storage_class.get_storage_classes()) {}

    Identifier::Identifier(std::string name, std::unique_ptr<BasicType> type)
        : name(name), type(std::move(type)) {}

    Void::Void()
        : BasicType(Type::VOID, Rep::NONE, 0) {}

    Int::Int(int width, bool is_signed, Qualifier qualifiers, StorageClass storage_class)
        : BasicType(Type::INT, is_signed ? Rep::SIGNED : Rep::UNSIGNED, width, qualifiers, storage_class) {}

    Float::Float(int width, Qualifier qualifiers, StorageClass storage_class)
        : BasicType(Type::FLOAT, Rep::FLOAT, width, qualifiers, storage_class) {}

    Struct::Struct(std::vector<std::unique_ptr<Identifier>> members, Qualifier qualifiers, StorageClass storage_class)
        : BasicType(Type::STRUCT, Rep::NONE, 0, qualifiers, storage_class), members(std::move(members)) {}

    Union::Union(std::vector<std::unique_ptr<Identifier>> members, Qualifier qualifiers, StorageClass storage_class)
        : BasicType(Type::UNION, Rep::NONE, 0, qualifiers, storage_class), members(std::move(members)) {}

    Pointer::Pointer(std::unique_ptr<BasicType> base, Qualifier qualifiers, StorageClass storage_class)
        : BasicType(Type::POINTER, Rep::NONE, 0, qualifiers, storage_class), base(std::move(base)) {}

    Array::Array(std::unique_ptr<BasicType> base, int dim, Qualifier qualifiers, StorageClass storage_class)
        : BasicType(Type::ARRAY, Rep::NONE, 0, qualifiers, storage_class), base(std::move(base)), dim(dim) {}

    Function::Function(std::vector<std::unique_ptr<Identifier>> parameters, std::unique_ptr<BasicType> return_type, Qualifier qualifiers, StorageClass storage_class)
        : BasicType(Type::FUNCTION, Rep::NONE, 0, qualifiers, storage_class), parameters(std::move(parameters)), return_type(std::move(return_type)) {}

    Typedef::Typedef(std::unique_ptr<BasicType> base, Qualifier qualifiers, StorageClass storage_class)
        : BasicType(Type::TYPEDEF, Rep::NONE, 0, qualifiers, storage_class), base(std::move(base)) {}

    Enum::Enum(std::vector<std::unique_ptr<BasicType>> members, Qualifier qualifiers, StorageClass storage_class)
        : BasicType(Type::ENUM, Rep::NONE, 0, qualifiers, storage_class), members(std::move(members)) {}

}