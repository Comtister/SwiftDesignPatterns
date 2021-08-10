import UIKit


//MARK:Singeleton Pattern
//Example 1
class DBManager{
    
    private static var dbManager : DBManager?
    
    private init(){
        
    }
    
    class func getObject() -> DBManager{
        
        if dbManager == nil{
            dbManager = DBManager()
        }
        
        return dbManager!
        
    }
    
    func saveValues(){}
    
}

//Example 2
class DBManagerTwo{
    
    static let shared : DBManagerTwo = DBManagerTwo()
    
    private init(){
        
    }
    
    func saveValues(){}
    
}

//MARK:Factory Method Pattern
//Example 1

class Para{
    
    private var deger : Int
    
    init(deger : Int) {
        self.deger = deger
    }
    
    var nominalDeger : String{
        get{
            return String("\(deger) TL")
        }
    }
    
    
}

class TL : Para{
    
    
    fileprivate override init(deger: Int) {
        super.init(deger: deger)
    }
    
}


protocol Darphane{
    func paraBas(nominalDeger : Int) -> Para
}

class TCDarphane : Darphane{
    
    func paraBas(nominalDeger: Int) -> Para {
        return TL(deger: 8)
    }
    
}

let banknot = TCDarphane().paraBas(nominalDeger: 5) as! TL

//MARK:Prototype Pattern
//Example 1

protocol Clonable{
    func clone() -> Any
}

class DBData : Clonable{
    
    var tablo : [Int]
    var id : String
    
    init(id : String , tablo : [Int]) {
        self.tablo = tablo
        self.id = id
    }
    
    func clone() -> Any {
        return DBData(id: self.id, tablo: self.tablo)
    }
    
}

let prototypeData = DBData(id: "id0", tablo: [0,1,2])

let dataOne = prototypeData.clone() as! DBData
dataOne.id = "id1"

//print(prototypeData.id)
//print(dataOne.id)

//MARK:Builder Pattern
//Example 1

class BankAccount{
    
    class Builder{
        
        var accountNumber : Int?
        var owner : String?
        var balance : Double?
        
        init(accountnumber : Int) {
            self.accountNumber = accountnumber
        }
        
        func openingBalance(balance : Double) -> Self{
            self.balance = balance
            return self
        }
        
        func isOwner(owner : String) -> Self{
            self.owner = owner
            return self
        }
        
        func build() -> BankAccount{
            
            let account = BankAccount()
            
            account.accountNumber = self.accountNumber
            account.balance = self.balance
            account.owner = self.owner
            
            return account
            
        }
        
    }
    
    
    var accountNumber : Int?
    var owner : String?
    var balance : Double?
    
    private init(){
        
    }
    
}

let accountOne = BankAccount.Builder(accountnumber: 0).build()
let accountTwo = BankAccount.Builder(accountnumber: 1).isOwner(owner: "Garry").openingBalance(balance: 500).build()

//Example 2


class BankAccountTwoBuilder{
    
    var accountNumber : Int?
    var owner : String?
    var balance : Double?
    
    typealias accountBuilder = (BankAccountTwoBuilder) -> Void
    
    init(builder : accountBuilder) {
        builder(self)
    }
    
}

class BankAccountTwo{
    
    var accountNumber : Int?
    var owner : String?
    var balance : Double?
    
    
    
    init?(builder : BankAccountTwoBuilder){
        
        if let accountNumber = builder.accountNumber{
            self.accountNumber = accountNumber
            self.owner = builder.owner
            self.balance = builder.balance
        }else{
            return nil
        }
        
    }
    
}

let accountOneBuilder = BankAccountTwoBuilder { (builder) in
    builder.accountNumber = 0
    builder.owner = "Garry"
    builder.balance = 500
}

let accountOneV = BankAccountTwo(builder: accountOneBuilder)

//MARK:Abstract Factory Pattern
//Example 1

protocol VasitaFactory{
    func createVasita(name : String) -> Vasita
}

protocol Vasita{
    
    var name : String { get set }
    
    func drive()
        
}

class BinekOto : Vasita{
    var name: String
    
    fileprivate init(name : String) {
        self.name = name
    }
    
    func drive() {
        print("Drive BinekOto")
    }
    
    
}

class Kamyon : Vasita{
    var name: String
    
    fileprivate init(name : String) {
        self.name = name
    }
    
    func drive() {
        print("Drive Kamyon")
    }
    
    
}

class BinekOtoFactory : VasitaFactory{
    func createVasita(name : String) -> Vasita {
        return BinekOto(name: name)
    }
    
}

class KamyonFactory : VasitaFactory{
    func createVasita(name: String) -> Vasita {
        return Kamyon(name: name)
    }
    
}

enum VasitaType{
    case Binek , Kamyon
}

class VasitaProvider{
    
    static func getProvider(vasitaType : VasitaType) -> VasitaFactory{
        
        switch vasitaType {
        case .Binek:
            return BinekOtoFactory()
        case .Kamyon:
            return KamyonFactory()
        }
        
    }
    
}

let vasita = VasitaProvider.getProvider(vasitaType: .Binek).createVasita(name: "dada")

vasita.drive()

//MARK:Iterator Pattern
//Example 1

struct User : Hashable{
    var id : String
    var name : String
}

protocol Iterator{
    func getAt(at : Int) -> User?
}

protocol Iterable{
    func getIterator() -> Iterator
}

class MatchList : Iterable{
    
    func getIterator() -> Iterator {
        return MatchIterator(list: self.list)
    }
    
    var list : [User : User]
    
    init(list : [User : User]) {
        self.list = list
    }
    
}

class FriendList : Iterable{
    func getIterator() -> Iterator {
        return FriendIterator(list: self.list)
    }
    
    var list : [User]
    
    init(list : [User]) {
        self.list = list
    }
    
}



class MatchIterator : Iterator{
    
    var list : [User : User]
    
    init(list : [User : User]) {
        self.list = list
    }
    
    func getAt(at: Int) -> User? {
        var tempList = list
        var returnValue : User? = nil
        for i in 0...at{
            let value = tempList.popFirst()
            if i == at{
                returnValue = value!.value
            }
        }
        return returnValue
    }
    
}

class FriendIterator : Iterator{
    
    var list : [User]
    
    init(list : [User]) {
        self.list = list
    }
    
    func getAt(at: Int) -> User? {
        if list.count - 1 <= at{
            return list[at]
        }else{
            return nil
        }
    }
    
    
}

//MARK:Observer Pattern
//Example 1
/*
protocol Observer : class{
   
    func onAction(data : Any)
}

protocol Observable{
    func notify(data : Any)
    func register(observer : Observer)
    func unRegister(observer : Observer)
}

class DataHandler : Observable{
    
    var data : Int = 0{
        didSet{
            notify(data: data)
        }
    }
    
    private var observers : [Observer] = [Observer]()
    
    func notify(data: Any) {
        observers.forEach { (observer) in
            observer.onAction(data: data)
        }
    }
    
    func register(observer: Observer) {
        observers.append(observer)
    }
    
    func unRegister(observer: Observer) {
        var index = 0
        for o in observers{
            if observer === o{
                observers.remove(at: index)
            }
            index += 1
        }
    }
    
}

class DataLookup : Observer{
   
    func onAction(data: Any) {
        print(data)
    }
    
}

let dataHandler = DataHandler()
let dataLookup = DataLookup()
dataHandler.register(observer: dataLookup)

dataHandler.data = 2
*/

//Example 2
/*
class ObservableValue<T>{
    
    private var value : T{
        didSet{
           
        }
    }
    
    init(value : T) {
        self.value = value
    }
    
    func setValue(value : T){
        self.value = value
    }
    
    func getValue() -> T{
        return value
    }
    
    func observe(change : (T) -> Void) {
        change(value)
    }
    
}*/

//MARK:MEDIATOR PATTERN
//Example 1
/*
enum FactoryActions{
    case start,stop,releaseProduct
}

protocol Dırector{
    func addFactory(factory : Factory)
    func removeFactory(factory : Factory)
    func sendMessage(from : Factory , to : Factory , message : FactoryActions)
    func broadcastMessage(from : Factory , message : FactoryActions)
}

protocol Factory : class{
    
    var working : Bool { get set }
    
    func startProduction()
    func stopProduction()
    func releaseProduct()
    func isWorking() -> Bool
}
    

class CentralManagement : Dırector{
   
    private var factories : [Factory] = [Factory]()
    
    func addFactory(factory: Factory) {
        factories.append(factory)
    }
    
    func removeFactory(factory: Factory) {
        var index = 0
        for f in factories{
            if factory === f{
                factories.remove(at: index)
            }
            index += 1
        }
    }
    
    func sendMessage(from : Factory , to: Factory, message: FactoryActions) {
        if message == .start{
            if to.isWorking(){
                print("factory already working")
            }else{
                to.startProduction()
            }
        }
        
        if message == .stop{
            if to.isWorking(){
                to.stopProduction()
            }else{
                print("factory already stopped")
            }
        }
        
    }
    
    func broadcastMessage(from : Factory , message : FactoryActions) {
        factories.forEach { (factory) in
            if message == .start{
                if factory.isWorking(){
                    print("Factory already working")
                }else{
                    factory.startProduction()
                }
            }
            if message == .stop{
                if factory.isWorking(){
                    factory.stopProduction()
                }else{
                    print("factory production stopped")
                }
            }
        }
    }
    
    
}

class FabrikOne : Factory{
    
    var working: Bool = false
    
    func startProduction() {
        working = true
        print("product One Started")
    }
    
    func stopProduction() {
        working = false
        print("product One stopped")
    }
    
    func releaseProduct() {
        working = false
        print("product One released")
    }
    
    func isWorking() -> Bool {
        return working
    }
    
    
}

class FabrikTwo : Factory{
    
    var working: Bool = false
    
    func startProduction() {
        working = true
        print("product Two Started")
    }
    
    func stopProduction() {
        working = false
        print("product Two stopped")
    }
    
    func releaseProduct() {
        working = false
        print("product Two released")
    }
    
    func isWorking() -> Bool {
        return working
    }
    
    
}

var fabrikOne = FabrikOne()
var fabrikTwo = FabrikTwo()

var centralManagament = CentralManagement()

centralManagament.addFactory(factory: fabrikOne)
centralManagament.addFactory(factory: fabrikTwo)

centralManagament.sendMessage(from: fabrikOne, to: fabrikTwo, message: .start)

*/

//MARK:Chain of Responsibility Pattern
//Example 1
/*
protocol DataProcess{
    var nextProcessor : DataProcess? { get set }
    
    func handleProcess(data : CustomData)
    
}

class CustomData{
    
    var priority : Int
    
    init(priority : Int) {
        self.priority = priority
    }
    
}

class FastProcessor : DataProcess{
    
    var nextProcessor: DataProcess?
    
    func handleProcess(data : CustomData) {
        if data.priority == 1{
            print("Handle data fast processor")
        }else if nextProcessor != nil{
            nextProcessor?.handleProcess(data: data)
        }else{
            print("Error")
        }
       
    }

}

class SlowProcessor : DataProcess{
    var nextProcessor: DataProcess?
    
    func handleProcess(data : CustomData) {
        if data.priority == 0{
            print("Handle data slow processor")
        }else if nextProcessor != nil{
            nextProcessor?.handleProcess(data: data)
        }else{
            print("error")
        }
       
    }
    
    
}

func getChain() -> DataProcess{
    let slowProcessor = SlowProcessor()
    let fastProcessor = FastProcessor()

    fastProcessor.nextProcessor = slowProcessor
    return fastProcessor
}

let data = CustomData(priority: 0)

let chain = getChain()
chain.handleProcess(data: data)
*/

//MARK:Command Pattern
//Example 1
/*
enum Commands{
    case create,destroy,rebuild
}

protocol Command{
    func execute()
}

class Fabrik{
    
    func createAuto(){
        print("auto creating")
    }
    
    func destroyAuto(){
        print("auto destroyed")
    }
    
    func rebuildAuto(){
        print("auto rebuild")
    }
    
}

class Create : Command{
    
    private let fabrik : Fabrik = Fabrik()
    
    func execute() {
        fabrik.createAuto()
    }
    
}

class Destroy : Command{
    
    private let fabrik : Fabrik = Fabrik()
    
    func execute() {
        fabrik.destroyAuto()
    }
    
}

class Rebuild : Command{
    
    private let fabrik : Fabrik = Fabrik()
    
    func execute() {
        fabrik.rebuildAuto()
    }
    
}

class Broker{
    
    var commands : [Commands : Command] = [Commands : Command]()
    
    init() {
        self.commands[Commands.create] = Create()
        self.commands[Commands.destroy] = Destroy()
        self.commands[Commands.rebuild] = Rebuild()
    }
    
    func RunCommand(command : Commands){
        commands[command]?.execute()
    }
    
}

let broker = Broker()

broker.RunCommand(command: .create)
*/

//MARK:Visitor Pattern
//Example 1
//Bir sınıf kendi olmayan olamayacak kalıtımı bozabilecek bir özelliği başka bir sınıftan çalıştırma durumudur.Çalıştırılacak sınıf sınıf fonksiyonuna verilir.
/*
protocol DObject{
    func accept(visitor : Visitor)
}

protocol Visitor{
    func visit(object : DObject)
}

class DataHandleVisitor : Visitor{
    
    func visit(object: DObject) {
        print("Data handling")
    }
    
}

class NetHandleVisitor : Visitor{
    func visit(object: DObject) {
        print("network handling")
    }
    
}

class TestObject : DObject{
    
    func accept(visitor: Visitor) {
        visitor.visit(object: self)
    }
    
}

let visitorOne = DataHandleVisitor()
let testO = TestObject()
testO.accept(visitor: visitorOne)
*/

//MARK:Strategy Pattern
//Example 1
/*
class SaveMethodProvider{
    
    private init(){
        
    }
    
    static func getSQL() -> SQLSave{
        return SQLSave()
    }
    
    static func getRealm() -> RealmSave{
        return RealmSave()
    }
    
}

protocol DataSave{
    func save()
}

class SQLSave : DataSave{
    func save() {
        print("save SQL")
    }
    
}

class RealmSave : DataSave{
    func save() {
        print("save realm")
    }
    
}

class DataHelper{
    func saveData(saveMethod : DataSave){
        saveMethod.save()
    }
}

let helper = DataHelper()
helper.saveData(saveMethod: SaveMethodProvider.getRealm())
*/

//MARK:State Pattern
//Example 1
/*
protocol State{
    func startFabrik(context : FabrikContext)
    func stopFabrik(context : FabrikContext)
    func waitingFabrik(context : FabrikContext)
}

class StoppedFabrik : State{
    
    func startFabrik(context : FabrikContext) {
        context.state = RunningFabrik()
        print("Fabrik starting")
    }
    
    func stopFabrik(context : FabrikContext) {
        print("Fabrik already stopped")
    }
    
    func waitingFabrik(context : FabrikContext) {
        print("Fabrik waiting")
    }
    
}

class RunningFabrik : State{
    
    func startFabrik(context : FabrikContext) {
        print("Fabrik already starting")
    }
    
    func stopFabrik(context : FabrikContext) {
        context.state = StoppedFabrik()
        print("Fabrik stopping")
    }
    
    func waitingFabrik(context : FabrikContext) {
        
        print("Fabrik waiting")
    }
    
}

class FabrikContext{
    
    var state : State?
    
    init() {
        self.state = StoppedFabrik()
    }

    func start(){
        state?.startFabrik(context: self)
    }
    
    func stop(){
        state?.stopFabrik(context: self)
    }
    
    func wait(){
        state?.waitingFabrik(context: self)
    }
    
}

let fbContext = FabrikContext()
fbContext.start()
fbContext.start()
fbContext.stop()
fbContext.stop()
*/


/*
//MARK:Memento Pattern
//Example 1

struct DataClassProperties{
    
    var dataId : String
    var data : [Int]
    
    init() {
        self.dataId = UUID().uuidString
        self.data = [0,0,0,0]
    }
    
}
//Originator
class DataClass{
    
    var state : DataClassProperties
    
    init() {
        self.state = DataClassProperties()
    }
    
    func createMemento() -> DataClassMemento{
        return DataClassMemento(state: state)
    }
    
    func setMemento(memento : DataClassMemento){
        self.state = memento.state
    }
  
    
}
//Memento
class DataClassMemento{
    
    private(set) var state : DataClassProperties
    
    init(state : DataClassProperties) {
        self.state = state
    }
    
}

class DataClassCareTaker{
    
    private(set) var mementos : [DataClassMemento] = [DataClassMemento]()
    
    func addMemento(memento : DataClassMemento){
        mementos.append(memento)
    }
    
    func getMemento(which : Int) -> DataClassMemento?{
        return mementos[which]
    }
    
}

let prop = DataClassProperties()
let data = DataClass()
let mem1 = data.createMemento()
let careTaker = DataClassCareTaker()
careTaker.addMemento(memento: mem1)
print(careTaker.getMemento(which: 0))
print(data.state.data)
data.state.data.append(12)
print(data.state.data)
data.setMemento(memento: mem1)
print(data.state.data)
*/


//MARK:Decorator Pattern
//Example 1
/*
class Window{
    
    var title : String
    
    init(title : String) {
        self.title = title
    }
    
    func render(){
        
    }
    
}

class LoginWindow : Window{
    
    override init(title: String) {
        super.init(title: title)
    }
    
    override func render() {
        print("Render Login Window")
    }
    
}

class PersonalWindow : Window{
    
    override init(title: String) {
        super.init(title: title)
    }
    
    override func render() {
        print("Render Personal window")
    }
    
}

class WindowDecorator : Window{
    
    var decorateObject : Window
    
    init(title : String , windowObject : Window) {
        self.decorateObject = windowObject
        super.init(title: title)
    }
    
    override func render() {
        decorateObject.render()
    }
    
}

class ThemeDecoretor : WindowDecorator{
    
    override init(title: String, windowObject: Window) {
        super.init(title: title, windowObject: windowObject)
    }
    
    func changeTheme(){
        print("\(decorateObject.title) Theme Change")
    }
    
}

class ScrollDecorator : WindowDecorator{
    
    override init(title: String, windowObject: Window) {
        super.init(title: title, windowObject: windowObject)
    }
    
    func scroll(){
        print("\(decorateObject.title) Scrolling")
    }
    
}

let loginW = LoginWindow(title: "First Login Window")
let personalW = PersonalWindow(title: "First Personal Window")

loginW.render()

let themeD = ThemeDecoretor(title: "deneme1", windowObject: loginW)
themeD.render()
themeD.changeTheme()
*/

//MARK:Facade Pattern
//Example 1
/*
class OperatorOne{
    
    func makeHospital(){
        print("making hospital")
    }
    
    func makeSchool(){
        print("making school")
    }
    
}

class OperatorTwo{
    
    func destroyHospital(){
        print("destroy hospital")
    }
    
    func destroySchool(){
        print("destroy schooll")
    }
    
}

class Facade{
    
    private var opOne : OperatorOne?
    private var opTwo : OperatorTwo?
    
    static var getFacade : Facade?{
        get{
            if instant == nil{
                instant = Facade()
            }
            return instant
        }
    }
    
    private static  var instant : Facade?
    
    private init(){
        self.opOne = OperatorOne()
        self.opTwo = OperatorTwo()
    }
    
    func actionOperatorOne(){
        opOne?.makeHospital()
        opOne?.makeSchool()
    }
    
    func actionOperatorTwo(){
        opTwo?.destroyHospital()
        opTwo?.destroySchool()
    }
    
}

Facade.getFacade?.actionOperatorOne()
Facade.getFacade?.actionOperatorTwo()
*/

//MARK:Bridge Pattern
//Example 1
/*
protocol Rank{
    
    func command()
    
}

class General : Rank{
    func command() {
        print("General Command")
    }
    
}

class Marshall : Rank{
    func command() {
        print("Marshall Command")

    }
    
}

protocol Squad{
    
    var rank : Rank { get set }
    
    func action()
    
}

class Land : Squad{
    var rank: Rank
    
    init(rank : Rank) {
        self.rank = rank
    }
    
    func action() {
        print("Land Troop Action \(rank.command())")

    }
    
    
}

class Sea : Squad{
    
    var rank: Rank
    
    init(rank : Rank) {
        self.rank = rank
    }
    
    func action() {
        print("Sea Troop Action \(rank.command())")
    }
    
}

let landSoldier = Land(rank: Marshall())
let landSoldierTwo = Land(rank: General())

landSoldier.action()
landSoldierTwo.action()
*/

//MARK:Composite pattern
//Example 1
/*
protocol View : class{
    func render()
}

class Button : View{
    
    private var name : String!
    
    init(name : String) {
        self.name = name
    }
    
    func render() {
        print("Buton Rendering\(self.name)")
    }
    
    
}

class Panel : View{
    
    private var children : [View] = [View]()
    
    func addItem(item : View){
        children.append(item)
    }
    
    func deleteItem(item : View){
        var index : Int = 0
        children.forEach { (view) in
            if item === view{
                children.remove(at: index)
            }
            index += 1
        }
    }
    
    func render() {
        children.forEach { (view) in
            view.render()
        }
    }
    
    
}

let panel1 = Panel()
let buton1 = Button(name: "Buton1")
let buton2 = Button(name: "Buton2")

panel1.addItem(item: buton1)
panel1.addItem(item: buton2)

let panel2 = Panel()
panel2.addItem(item: panel1)


panel1.render()
*/


//MARK:Flyweight Pattern
//Example 1

/*
class Location{
    
    var x : Int
    var y : Int
    var soldier : Soldier
    
    init(x : Int , y : Int , soldier : Soldier) {
        self.x = x
        self.y = y
        self.soldier = soldier
    }
    
    
}
//flyweight object
class Soldier{
    
    var rank : String
    var pros : String
    
    init(rank : String , pros : String) {
        self.rank = rank
        self.pros = pros
    }
    
}

class FlyWeightManager{
    
    
    static let shared = FlyWeightManager()
    private var flyweigths : [String : Soldier] = [String : Soldier]()
    
    private init(){
        
    }
    
   func createobject(id : String) -> Location{
        
    var tempIntrinsic : Soldier?
    
    
    
    return Location(x: 5, y: 5, soldier: flyweigths["id"]!)
        
    }
    
}

*/

//MARK:Delegation Pattern
//Example 1
/*
protocol FactoryDelegate{
    
    func produce()
    
}

class FactoryOne{
    

    var delegate : FactoryDelegate?
    
    func produce() {
        delegate?.produce()
    }
    
    
}

class FactoryTwo : FactoryDelegate{
    
    var factory : FactoryOne = FactoryOne()
    
    init() {
        
    }
    
    func setDelegate(){
        factory.delegate = self
    }
    
    func produce() {
        print("Run Factory Two")
    }
    
    
}

let factory = FactoryTwo()
factory.setDelegate()
factory.factory.produce()
*/


