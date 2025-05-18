/*

// Allows specifying multiple variants to be rendered by `openscad-auto`: https://github.com/lgarron/dotfiles/blob/main/scripts/app-tools/openscad-auto.rs
//
// Each variant is a string, which must defined as an entry in a global BOSL2 struct named `VARIANT_DATA`.
//
// - The struct must contain an entry with the key `"default"`.
// - Keys are used in file names.
//   - They must not contain the character `.`, as this is used to compose variants (see below).
//   - Keys are used to create file names, so it is worth using names that will be as clear as possible in this context.
// - The value of each entry is a list containing:
//   - A required first item with a BOSL2 struct specifying a mapping of parameter names to values.
//   - An optional second item containing a list of parent variants to inherit from.
//     - Later entries override earlier entries.
//
// Each variant falls back to the parameter value from the `"default"` entry if it is not specified among the ancestors of a given entry.
// Note that the top-level order of entries has no effect on the parameter calculations. Parameter inheritance for a variant depends solely on the ordering of its parents (and their parents, recursively).
//
// The variant it specified in a global `VARIANT` var.
//
// - Multiple variants may be composed by specifying them with a `.` inbetween.
//   - Note that such variants can be defined explicitly in `VARIANT_DATA` by specifying those variants as parents. However, the compositional approach is a very convenient mechanism to avoid boilerplate.
//
// Parameters are computed by calling `get_parameter(parameter_name)` after `VARIANT` and `VARIANT_DATA` have been defined.
//
// Example usage:

VARIANT = "default"; // ["default", "no-version", "mini", "mini.normal-height"]

VARIANT_DATA = [
  [
    "default",
    [
      [
        ["TOTAL_HEIGHT", 5],
        ["TRIANGLE_EDGE_LENGTH", 25],
        ["INCLUDE_VERSION_ENGRAVING", true],
      ],
    ],
  ],
  [
    "no-version",
    [
      [
        ["INCLUDE_VERSION_ENGRAVING", false],
      ],
    ],
  ],
  [
    "mini",
    [
      [
        ["TOTAL_HEIGHT", 3],
        ["TRIANGLE_EDGE_LENGTH", 15],
      ],
      // Don't include the version for `mini` (it's small)
      ["no-version"]
    ],
  ],
  [
    "normal-height",
    [
      [
        ["TOTAL_HEIGHT", 5],
      ],
    ],
  ]
];

include <./node_modules/scad/variants.scad>

TOTAL_HEIGHT = get_parameter("TOTAL_HEIGHT");
TRIANGLE_EDGE_LENGTH = get_parameter("TRIANGLE_EDGE_LENGTH");
INCLUDE_VERSION_ENGRAVING = get_parameter("INCLUDE_VERSION_ENGRAVING");

*/


include <./vendor/BOSL2/std.scad>

/*

type undef = undefined;
type ParameterValue = string | number;

type Struct<KeyType, ValueType> = [string, ValueType][];
type VariantID = string;
type ParameterName = string;
type VariantParameters = Struct<ParameterName, ParameterValue>;
type VariantInheritanceChain = VariantID[]; // Semantics: inheritance chain (later entries take priority)
type VariantEntry =
  | [VariantParameters]
  | [VariantParameters, VariantInheritanceChain];
type VariantData = Struct<VariantID, VariantEntry>;

// Global vars which must be set by the calling code.
export const VARIANT: string; // Variants delimited by `.`
export const VARIANT_DATA: VariantData;

*/

// function __variants__variant_parameters(variant_entry: VariantEntry): VariantParameters;
function __variants__variant_parameters(variant_entry) = variant_entry[0];
// function __variants__variant_parents(variant_entry: VariantEntry): [VariantID];
function __variants__variant_parents(variant_entry) = len(variant_entry) > 1 ? variant_entry[1] : [];

// function __variants__maybe_get_parameter_for_variant(parameter_name: ParameterName, variant_id: VariantID, variant_ids_in_recursion_stack_for_cycle_detection: VariantID[]): ParameterValue | undef;
function __variants__maybe_get_parameter_for_variant(parameter_name, variant_id, variant_ids_in_recursion_stack_for_cycle_detection) =
  // echo("__variants__maybe_get_parameter_for_variant", parameter_name, variant_id, variant_ids_in_recursion_stack_for_cycle_detection)
  assert(is_undef(str_find(variant_id, ".")), "Encountered a variant which contains the period (`.`) character. This character is used to delimit variants, and cannot be part of a variant ID directly")
  assert(!in_list(variant_id, variant_ids_in_recursion_stack_for_cycle_detection), str("Encountered recursively defined variants at the following variant: ", variant_id))
  let (
    variant_entry = struct_val(VARIANT_DATA, variant_id),
  ) assert(!is_undef(variant_entry), str("Variant is missing: ", variant_id)) // Technically we're doing unnecessary string concatentation in the "happy" path, but this should be cheap enough.
  let (
    direct_value = struct_val(__variants__variant_parameters(variant_entry), parameter_name)) is_undef(direct_value) ? __variants__maybe_get_parameter_for_variants(parameter_name, __variants__variant_parents(variant_entry), concat(variant_ids_in_recursion_stack_for_cycle_detection, [variant_id])) : direct_value;
;

// function __variants__maybe_get_parameter_for_variants(parameter_name: ParameterName, variants: VariantID[], variant_ids_in_recursion_stack_for_cycle_detection: VariantID[]): ParameterValue | undef;
function __variants__maybe_get_parameter_for_variants(parameter_name, variant_ids, variant_ids_in_recursion_stack_for_cycle_detection) =
  // echo("__variants__maybe_get_parameter_for_variants", parameter_name, variant_ids, variant_ids_in_recursion_stack_for_cycle_detection)
  len(variant_ids) == 0 ? undef
  : (
    let (maybe_value = __variants__maybe_get_parameter_for_variant(parameter_name, last(variant_ids), variant_ids_in_recursion_stack_for_cycle_detection)) is_undef(maybe_value) ? __variants__maybe_get_parameter_for_variants(parameter_name, list_head(variant_ids), variant_ids_in_recursion_stack_for_cycle_detection) : maybe_value
  );

// export function get_parameter(parameter_name: ParameterName): ParameterValue;
function get_parameter(parameter_name) =
  assert(!is_undef(VARIANT), "The global variable `VARIANT` must be set before calling `get_parameter(…)`") // TODO: doesn't work
  assert(!is_undef(VARIANT_DATA), "The global variable `VARIANT_DATA` must be set before calling `get_parameter(…)`") // TODO: doesn't work
  let (default_entry = struct_val(VARIANT_DATA, "default"))
  assert(!is_undef(default_entry), "An entry for the variant `\"default\"` must be present in `VARIANT_DATA`/")
  let (default_entry_value_for_parameter = struct_val(__variants__variant_parameters(default_entry), parameter_name))
  assert(!is_undef(default_entry_value_for_parameter), str("Parameter is missing from the `\"default\"` entry in `VARIANT_DATA` (all parameters must be defined on the default variant): ", parameter_name))
  let (
    variant_ids = str_split(VARIANT, "."),
    maybe_value = __variants__maybe_get_parameter_for_variants(parameter_name, concat(["default"], variant_ids), []),
  ) 
  let (value = is_undef(maybe_value) ? __variants__maybe_get_parameter_for_variant(parameter_name, "default", []) : maybe_value) assert(!is_undef(value), str("Unable to get parameter: ", parameter_name)) // Technically we're doing unnecessary string concatentation in the "happy" path, but this should be cheap enough.
  value;
