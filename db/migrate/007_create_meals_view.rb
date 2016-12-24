Sequel.migration do
  up do
    create_view(:meals, <<~'SQL')
      SELECT
        food_entries.user_id,
        food_entries.date,
        food_entries.meal_name,
        foods.description AS food,
        foods.brand AS brand,
        FLOOR(((food_portions.gram_weight * food_entries.quantity * foods.calories) / foods.grams)::numeric) AS total_calories,
        food_portions.description AS portion
      FROM food_entries
      JOIN food_portions ON food_entries.portion_id = food_portions.id
      JOIN foods ON foods.id = food_id
    SQL
  end

  down do
    drop_view(:meals)
  end
end
