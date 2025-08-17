import uuid
import asyncio
from fastapi_users.password import PasswordHelper
from sqlalchemy import select, func
from datetime import datetime, timedelta
from backend.app.core.models.db import AsyncSessionLocal, Base, engine
from backend.app.core.models import models

ph = PasswordHelper()

def hp(password: str) -> str:
    return ph.hash(password)

# Категории
categories = [
    models.Category(id=str(uuid.uuid4()), name="Овощи", image_url="/images/categories/vegetables.png"),
    models.Category(id=str(uuid.uuid4()), name="Фрукты", image_url="/images/categories/fruits.png"),
    models.Category(id=str(uuid.uuid4()), name="Молочные продукты", image_url="/images/categories/dairy.png"),
    models.Category(id=str(uuid.uuid4()), name="Мясо и птица", image_url="/images/categories/meat.png"),
    models.Category(id=str(uuid.uuid4()), name="Рыба и морепродукты", image_url="/images/categories/seafood.png"),
    models.Category(id=str(uuid.uuid4()), name="Хлеб и выпечка", image_url="/images/categories/bakery.png"),
    models.Category(id=str(uuid.uuid4()), name="Напитки", image_url="/images/categories/beverages.png"),
    models.Category(id=str(uuid.uuid4()), name="Крупы и макароны", image_url="/images/categories/grains.png"),
    models.Category(id=str(uuid.uuid4()), name="Консервы", image_url="/images/categories/canned.png"),
    models.Category(id=str(uuid.uuid4()), name="Сладости", image_url="/images/categories/sweets.png")
]

# Продукты (50 записей)
products = [
    # Овощи
    models.Product(id=str(uuid.uuid4()), name="Огурцы 1кг", description="Свежие огурцы с грядки", image_url="/images/products/cucumber.png", price=129.00, category_id=categories[0].id, stock=120, rating=4.2, calories=15, weight=1.0, country="Россия"),
    models.Product(id=str(uuid.uuid4()), name="Помидоры 1кг", description="Сочные томаты", image_url="/images/products/tomato.png", price=149.00, category_id=categories[0].id, stock=100, rating=4.5, calories=18, weight=1.0, country="Россия"),
    models.Product(id=str(uuid.uuid4()), name="Картофель 1кг", description="Молодой картофель", image_url="/images/products/potato.png", price=59.00, category_id=categories[0].id, stock=200, rating=4.0, calories=77, weight=1.0, country="Беларусь"),
    models.Product(id=str(uuid.uuid4()), name="Морковь 1кг", description="Сладкая морковь", image_url="/images/products/carrot.png", price=69.00, category_id=categories[0].id, stock=150, rating=4.3, calories=41, weight=1.0, country="Россия"),
    models.Product(id=str(uuid.uuid4()), name="Капуста белокочанная 1кг", description="Свежая капуста", image_url="/images/products/cabbage.png", price=49.00, category_id=categories[0].id, stock=80, rating=4.1, calories=25, weight=1.0, country="Россия"),
    # Фрукты
    models.Product(id=str(uuid.uuid4()), name="Яблоки Гренни 1кг", description="Сочные яблоки", image_url="/images/products/apples.png", price=150.00, category_id=categories[1].id, stock=80, rating=4.8, calories=52, weight=1.0, country="Польша"),
    models.Product(id=str(uuid.uuid4()), name="Бананы 1кг", description="Спелые бананы", image_url="/images/products/banana.png", price=99.00, category_id=categories[1].id, stock=200, rating=4.6, calories=89, weight=1.0, country="Эквадор"),
    models.Product(id=str(uuid.uuid4()), name="Апельсины 1кг", description="Сладкие апельсины", image_url="/images/products/orange.png", price=120.00, category_id=categories[1].id, stock=150, rating=4.4, calories=47, weight=1.0, country="Испания"),
    models.Product(id=str(uuid.uuid4()), name="Груши 1кг", description="Спелые груши", image_url="/images/products/pear.png", price=140.00, category_id=categories[1].id, stock=90, rating=4.3, calories=57, weight=1.0, country="Италия"),
    models.Product(id=str(uuid.uuid4()), name="Виноград 1кг", description="Красный виноград", image_url="/images/products/grape.png", price=180.00, category_id=categories[1].id, stock=70, rating=4.7, calories=69, weight=1.0, country="Чили"),
    # Молочные продукты
    models.Product(id=str(uuid.uuid4()), name="Молоко 1л", description="Фермерское молоко", image_url="/images/products/milk.png", price=89.00, category_id=categories[2].id, stock=100, rating=4.5, composition="Молоко коровье пастеризованное", nutritional_value="Белки: 3.2г, Жиры: 3.6г, Углеводы: 4.7г", calories=60, weight=1.0, country="Россия"),
    models.Product(id=str(uuid.uuid4()), name="Сыр Гауда 200г", description="Твердый сыр", image_url="/images/products/cheese.png", price=250.00, category_id=categories[2].id, stock=60, rating=4.8, composition="Молоко, соль, закваска", nutritional_value="Белки: 25г, Жиры: 27г", calories=356, weight=0.2, country="Нидерланды"),
    models.Product(id=str(uuid.uuid4()), name="Йогурт натуральный 500г", description="Без добавок", image_url="/images/products/yogurt.png", price=90.00, category_id=categories[2].id, stock=120, rating=4.2, composition="Молоко, закваска", nutritional_value="Белки: 3.5г, Жиры: 3.2г, Углеводы: 4.0г", calories=61, weight=0.5, country="Россия"),
    models.Product(id=str(uuid.uuid4()), name="Сметана 20% 400г", description="Натуральная сметана", image_url="/images/products/sour_cream.png", price=110.00, category_id=categories[2].id, stock=80, rating=4.4, composition="Сливки, закваска", nutritional_value="Белки: 2.5г, Жиры: 20г", calories=204, weight=0.4, country="Россия"),
    models.Product(id=str(uuid.uuid4()), name="Творог 5% 250г", description="Мягкий творог", image_url="/images/products/cottage_cheese.png", price=80.00, category_id=categories[2].id, stock=100, rating=4.3, composition="Молоко, закваска", nutritional_value="Белки: 16г, Жиры: 5г", calories=121, weight=0.25, country="Россия"),
    # Мясо и птица
    models.Product(id=str(uuid.uuid4()), name="Куриная грудка 1кг", description="Свежая курица", image_url="/images/products/chicken_breast.png", price=350.00, category_id=categories[3].id, stock=90, rating=4.6, calories=165, weight=1.0, country="Россия"),
    models.Product(id=str(uuid.uuid4()), name="Говядина 1кг", description="Мякоть говядины", image_url="/images/products/beef.png", price=600.00, category_id=categories[3].id, stock=70, rating=4.7, calories=187, weight=1.0, country="Россия"),
    models.Product(id=str(uuid.uuid4()), name="Свинина 1кг", description="Свиная вырезка", image_url="/images/products/pork.png", price=450.00, category_id=categories[3].id, stock=80, rating=4.5, calories=242, weight=1.0, country="Россия"),
    models.Product(id=str(uuid.uuid4()), name="Куриные крылья 1кг", description="Свежие крылья", image_url="/images/products/chicken_wings.png", price=280.00, category_id=categories[3].id, stock=100, rating=4.4, calories=203, weight=1.0, country="Россия"),
    models.Product(id=str(uuid.uuid4()), name="Индейка филе 1кг", description="Филе индейки", image_url="/images/products/turkey.png", price=400.00, category_id=categories[3].id, stock=60, rating=4.6, calories=144, weight=1.0, country="Россия"),
    # Рыба и морепродукты
    models.Product(id=str(uuid.uuid4()), name="Лосось филе 500г", description="Свежий лосось", image_url="/images/products/salmon.png", price=800.00, category_id=categories[4].id, stock=50, rating=4.9, calories=208, weight=0.5, country="Норвегия"),
    models.Product(id=str(uuid.uuid4()), name="Креветки 1кг", description="Очищенные креветки", image_url="/images/products/shrimp.png", price=1200.00, category_id=categories[4].id, stock=40, rating=4.8, calories=99, weight=1.0, country="Таиланд"),
    models.Product(id=str(uuid.uuid4()), name="Треска филе 500г", description="Филе трески", image_url="/images/products/cod.png", price=500.00, category_id=categories[4].id, stock=60, rating=4.7, calories=82, weight=0.5, country="Россия"),
    models.Product(id=str(uuid.uuid4()), name="Мидии 1кг", description="Свежие мидии", image_url="/images/products/mussels.png", price=600.00, category_id=categories[4].id, stock=50, rating=4.6, calories=77, weight=1.0, country="Чили"),
    models.Product(id=str(uuid.uuid4()), name="Кальмар 1кг", description="Очищенный кальмар", image_url="/images/products/squid.png", price=450.00, category_id=categories[4].id, stock=70, rating=4.5, calories=92, weight=1.0, country="Китай"),
    # Хлеб и выпечка
    models.Product(id=str(uuid.uuid4()), name="Хлеб белый 400г", description="Свежий белый хлеб", image_url="/images/products/white_bread.png", price=50.00, category_id=categories[5].id, stock=200, rating=4.3, calories=265, weight=0.4, country="Россия"),
    models.Product(id=str(uuid.uuid4()), name="Багет 300г", description="Французский багет", image_url="/images/products/baguette.png", price=70.00, category_id=categories[5].id, stock=150, rating=4.5, calories=289, weight=0.3, country="Россия"),
    models.Product(id=str(uuid.uuid4()), name="Круассан 100г", description="Сливочный круассан", image_url="/images/products/croissant.png", price=60.00, category_id=categories[5].id, stock=100, rating=4.6, calories=406, weight=0.1, country="Россия"),
    models.Product(id=str(uuid.uuid4()), name="Ржаной хлеб 500г", description="Ржаной хлеб", image_url="/images/products/rye_bread.png", price=65.00, category_id=categories[5].id, stock=120, rating=4.4, calories=250, weight=0.5, country="Россия"),
    models.Product(id=str(uuid.uuid4()), name="Пирожки с яблоком 200г", description="Пирожки с яблочной начинкой", image_url="/images/products/apple_pie.png", price=80.00, category_id=categories[5].id, stock=90, rating=4.5, calories=240, weight=0.2, country="Россия"),
    # Напитки
    models.Product(id=str(uuid.uuid4()), name="Кока-кола 1л", description="Газированный напиток", image_url="/images/products/cola.png", price=90.00, category_id=categories[6].id, stock=200, rating=4.2, calories=42, weight=1.0, country="Россия"),
    models.Product(id=str(uuid.uuid4()), name="Сок апельсиновый 1л", description="Натуральный сок", image_url="/images/products/orange_juice.png", price=120.00, category_id=categories[6].id, stock=150, rating=4.4, calories=45, weight=1.0, country="Россия"),
    models.Product(id=str(uuid.uuid4()), name="Вода минеральная 1л", description="Без газа", image_url="/images/products/water.png", price=40.00, category_id=categories[6].id, stock=300, rating=4.0, calories=0, weight=1.0, country="Россия"),
    models.Product(id=str(uuid.uuid4()), name="Чай черный 100г", description="Листовой чай", image_url="/images/products/tea.png", price=150.00, category_id=categories[6].id, stock=100, rating=4.3, calories=0, weight=0.1, country="Индия"),
    models.Product(id=str(uuid.uuid4()), name="Кофе молотый 250г", description="Арабика", image_url="/images/products/coffee.png", price=300.00, category_id=categories[6].id, stock=80, rating=4.7, calories=0, weight=0.25, country="Бразилия"),
    # Крупы и макароны
    models.Product(id=str(uuid.uuid4()), name="Рис басмати 1кг", description="Длиннозерный рис", image_url="/images/products/rice.png", price=200.00, category_id=categories[7].id, stock=100, rating=4.5, calories=130, weight=1.0, country="Индия"),
    models.Product(id=str(uuid.uuid4()), name="Макароны спагетти 500г", description="Итальянские спагетти", image_url="/images/products/spaghetti.png", price=80.00, category_id=categories[7].id, stock=150, rating=4.4, calories=131, weight=0.5, country="Италия"),
    models.Product(id=str(uuid.uuid4()), name="Гречка 1кг", description="Ядрица", image_url="/images/products/buckwheat.png", price=90.00, category_id=categories[7].id, stock=120, rating=4.3, calories=123, weight=1.0, country="Россия"),
    models.Product(id=str(uuid.uuid4()), name="Овсянка 500г", description="Овсяные хлопья", image_url="/images/products/oats.png", price=60.00, category_id=categories[7].id, stock=200, rating=4.2, calories=366, weight=0.5, country="Россия"),
    models.Product(id=str(uuid.uuid4()), name="Пшено 1кг", description="Пшено высшего сорта", image_url="/images/products/millet.png", price=70.00, category_id=categories[7].id, stock=100, rating=4.1, calories=378, weight=1.0, country="Россия"),
    # Консервы
    models.Product(id=str(uuid.uuid4()), name="Тунец консервированный 185г", description="Тунец в собственном соку", image_url="/images/products/tuna.png", price=150.00, category_id=categories[8].id, stock=100, rating=4.6, calories=96, weight=0.185, country="Таиланд"),
    models.Product(id=str(uuid.uuid4()), name="Кукуруза консервированная 400г", description="Сладкая кукуруза", image_url="/images/products/corn.png", price=80.00, category_id=categories[8].id, stock=150, rating=4.3, calories=58, weight=0.4, country="Россия"),
    models.Product(id=str(uuid.uuid4()), name="Зеленый горошек 400г", description="Консервированный горошек", image_url="/images/products/peas.png", price=70.00, category_id=categories[8].id, stock=120, rating=4.2, calories=55, weight=0.4, country="Россия"),
    models.Product(id=str(uuid.uuid4()), name="Фасоль красная 400г", description="Консервированная фасоль", image_url="/images/products/beans.png", price=90.00, category_id=categories[8].id, stock=100, rating=4.3, calories=99, weight=0.4, country="Россия"),
    models.Product(id=str(uuid.uuid4()), name="Ананасы консервированные 565г", description="Кольца ананаса", image_url="/images/products/pineapple.png", price=120.00, category_id=categories[8].id, stock=80, rating=4.5, calories=60, weight=0.565, country="Таиланд"),
    # Сладости
    models.Product(id=str(uuid.uuid4()), name="Шоколад молочный 100г", description="Молочный шоколад", image_url="/images/products/chocolate.png", price=100.00, category_id=categories[9].id, stock=200, rating=4.7, calories=535, weight=0.1, country="Россия"),
    models.Product(id=str(uuid.uuid4()), name="Печенье овсяное 300г", description="Овсяное печенье", image_url="/images/products/cookies.png", price=80.00, category_id=categories[9].id, stock=150, rating=4.4, calories=437, weight=0.3, country="Россия"),
    models.Product(id=str(uuid.uuid4()), name="Конфеты карамель 200г", description="Карамель с начинкой", image_url="/images/products/caramel.png", price=90.00, category_id=categories[9].id, stock=120, rating=4.3, calories=400, weight=0.2, country="Россия"),
    models.Product(id=str(uuid.uuid4()), name="Мармелад 250г", description="Фруктовый мармелад", image_url="/images/products/jelly.png", price=70.00, category_id=categories[9].id, stock=100, rating=4.2, calories=321, weight=0.25, country="Россия"),
    models.Product(id=str(uuid.uuid4()), name="Зефир 300г", description="Ванильный зефир", image_url="/images/products/marshmallow.png", price=85.00, category_id=categories[9].id, stock=90, rating=4.4, calories=326, weight=0.3, country="Россия")
]

# Пользователи
users = [
    models.User(id=str(uuid.uuid4()), phone_number="+79991234567", name="Иван Иванов", role="user", is_active=True, is_verified=True, is_superuser=False, email="example1@pochta.ru", hashed_password=hp("Passw0rd!")),
    models.User(id=str(uuid.uuid4()), phone_number="+79991234568", name="Мария Петрова", role="user", is_active=True, is_verified=True, is_superuser=False, email="example2@pochta.ru", hashed_password=hp("Passw0rd!")),
    models.User(id=str(uuid.uuid4()), phone_number="+79991234569", name="Алексей Смирнов", role="user", is_active=True, is_verified=True, is_superuser=False, email="example3@pochta.ru", hashed_password=hp("Passw0rd!")),
    models.User(id=str(uuid.uuid4()), phone_number="+79991234570", name="Елена Кузнецова", role="user", is_active=True, is_verified=True, is_superuser=False, email="example4@pochta.ru", hashed_password=hp("Passw0rd!")),
    models.User(id=str(uuid.uuid4()), phone_number="+79991234571", name="Дмитрий Соколов", role="user", is_active=True, is_verified=True, is_superuser=False, email="example5@pochta.ru", hashed_password=hp("Passw0rd!"))
]

# Заказы
orders = [
    models.Order(id=str(uuid.uuid4()), user_phone="+79991234567", user_id=users[0].id, delivery_address="Москва, ул. Ленина, 10", delivery_time=datetime.now() + timedelta(days=1), total_price=218.00, status=models.OrderStatus.created),
    models.Order(id=str(uuid.uuid4()), user_phone="+79991234568", user_id=users[1].id, delivery_address="Москва, ул. Мира, 5", delivery_time=datetime.now() + timedelta(days=2), total_price=350.00, status=models.OrderStatus.processing),
    models.Order(id=str(uuid.uuid4()), user_phone="+79991234569", user_id=users[2].id, delivery_address="Москва, ул. Победы, 15", delivery_time=datetime.now() + timedelta(days=1), total_price=500.00, status=models.OrderStatus.delivered),
    models.Order(id=str(uuid.uuid4()), user_phone="+79991234570", user_id=users[3].id, delivery_address="Москва, ул. Садовая, 20", delivery_time=datetime.now() + timedelta(days=3), total_price=270.00, status=models.OrderStatus.created),
    models.Order(id=str(uuid.uuid4()), user_phone="+79991234571", user_id=users[4].id, delivery_address="Москва, ул. Центральная, 30", delivery_time=datetime.now() + timedelta(days=2), total_price=400.00, status=models.OrderStatus.processing),
    models.Order(id=str(uuid.uuid4()), user_phone="+79991234567", user_id=users[0].id, delivery_address="Москва, ул. Ленина, 10", delivery_time=datetime.now() + timedelta(days=1), total_price=180.00, status=models.OrderStatus.created),
    models.Order(id=str(uuid.uuid4()), user_phone="+79991234568", user_id=users[1].id, delivery_address="Москва, ул. Мира, 5", delivery_time=datetime.now() + timedelta(days=2), total_price=300.00, status=models.OrderStatus.delivered),
    models.Order(id=str(uuid.uuid4()), user_phone="+79991234569", user_id=users[2].id, delivery_address="Москва, ул. Победы, 15", delivery_time=datetime.now() + timedelta(days=1), total_price=450.00, status=models.OrderStatus.processing),
    models.Order(id=str(uuid.uuid4()), user_phone="+79991234570", user_id=users[3].id, delivery_address="Москва, ул. Садовая, 20", delivery_time=datetime.now() + timedelta(days=3), total_price=200.00, status=models.OrderStatus.created),
    models.Order(id=str(uuid.uuid4()), user_phone="+79991234571", user_id=users[4].id, delivery_address="Москва, ул. Центральная, 30", delivery_time=datetime.now() + timedelta(days=2), total_price=320.00, status=models.OrderStatus.delivered)
]

# Элементы заказа
order_items = [
    models.OrderItem(id=str(uuid.uuid4()), order_id=orders[0].id, product_id=products[0].id, quantity=2, price=129.00),
    models.OrderItem(id=str(uuid.uuid4()), order_id=orders[0].id, product_id=products[10].id, quantity=1, price=89.00),
    models.OrderItem(id=str(uuid.uuid4()), order_id=orders[1].id, product_id=products[5].id, quantity=2, price=150.00),
    models.OrderItem(id=str(uuid.uuid4()), order_id=orders[1].id, product_id=products[15].id, quantity=1, price=350.00),
    models.OrderItem(id=str(uuid.uuid4()), order_id=orders[2].id, product_id=products[20].id, quantity=1, price=800.00),
    models.OrderItem(id=str(uuid.uuid4()), order_id=orders[2].id, product_id=products[25].id, quantity=2, price=50.00),
    models.OrderItem(id=str(uuid.uuid4()), order_id=orders[3].id, product_id=products[1].id, quantity=1, price=149.00),
    models.OrderItem(id=str(uuid.uuid4()), order_id=orders[3].id, product_id=products[11].id, quantity=1, price=250.00),
    models.OrderItem(id=str(uuid.uuid4()), order_id=orders[4].id, product_id=products[30].id, quantity=2, price=90.00),
    models.OrderItem(id=str(uuid.uuid4()), order_id=orders[4].id, product_id=products[35].id, quantity=1, price=200.00),
    models.OrderItem(id=str(uuid.uuid4()), order_id=orders[5].id, product_id=products[2].id, quantity=3, price=59.00),
    models.OrderItem(id=str(uuid.uuid4()), order_id=orders[5].id, product_id=products[12].id, quantity=1, price=90.00),
    models.OrderItem(id=str(uuid.uuid4()), order_id=orders[6].id, product_id=products[6].id, quantity=2, price=99.00),
    models.OrderItem(id=str(uuid.uuid4()), order_id=orders[6].id, product_id=products[16].id, quantity=1, price=600.00),
    models.OrderItem(id=str(uuid.uuid4()), order_id=orders[7].id, product_id=products[21].id, quantity=1, price=1200.00),
    models.OrderItem(id=str(uuid.uuid4()), order_id=orders[7].id, product_id=products[26].id, quantity=2, price=70.00),
    models.OrderItem(id=str(uuid.uuid4()), order_id=orders[8].id, product_id=products[3].id, quantity=2, price=69.00),
    models.OrderItem(id=str(uuid.uuid4()), order_id=orders[8].id, product_id=products[13].id, quantity=1, price=110.00),
    models.OrderItem(id=str(uuid.uuid4()), order_id=orders[9].id, product_id=products[40].id, quantity=2, price=100.00),
    models.OrderItem(id=str(uuid.uuid4()), order_id=orders[9].id, product_id=products[45].id, quantity=1, price=150.00)
]

async def seed_data():
    # создаём таблицы (для AsyncEngine — только через run_sync)
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

    # открываем async-сессию корректно
    async with AsyncSessionLocal() as db:
        try:
            print("Starting to seed data...")

            # категории
            if categories:
                db.add_all(categories)
                await db.commit()
                print("Categories added successfully")

            # продукты
            if products:
                db.add_all(products)
                await db.commit()
                print("Products added successfully")

            # пользователи
            if users:
                db.add_all(users)
                await db.commit()
                print("Users added successfully")

            # заказы
            if orders:
                db.add_all(orders)
                await db.commit()
                print("Orders added successfully")

            # позиции заказов
            if order_items:
                db.add_all(order_items)
                await db.commit()
                print("Order items added successfully")

            print("Data seeding completed successfully")

        except Exception as e:
            print(f"Error during data seeding: {e}")
            await db.rollback()   # <-- тоже await
            raise                 # полезно пробросить ошибку, чтобы видеть трейс

if __name__ == "__main__":
    asyncio.run(seed_data())

