#pragma once

#include <cstddef>
#include <ostream>
#include <utility>

namespace frontend
{
    using position_t = std::size_t;
    using location_t = std::pair<std::size_t, std::size_t>;
}

inline std::ostream& operator<<(std::ostream& os, const frontend::location_t& loc)
{
    return os << "[" << loc.first << "-" << loc.second << "]";
}