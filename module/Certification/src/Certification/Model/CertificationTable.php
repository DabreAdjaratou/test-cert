<?php

namespace Certification\Model;

use Zend\Db\TableGateway\TableGateway;

class CertificationTable {

    protected $tableGateway;

    public function __construct(TableGateway $tableGateway) {
        $this->tableGateway = $tableGateway;
    }

    public function fetchAll() {
        $sqlSelect = $this->tableGateway->getSql()->select();
        $sqlSelect->columns(array('id', 'examination', 'final_decision', 'certification_issuer', 'date_certificate_issued', 'date_certificate_sent', 'certification_type'));
        $sqlSelect->join('examination', 'examination.id = certification.examination ', array('provider'), 'left')
                ->join('provider', 'provider.id = examination.provider ', array('last_name', 'first_name', 'middle_name', 'certification_id', 'certification_reg_no', 'professional_reg_no'), 'left')
                ->where(array('final_decision' => 'certified'));
        $sqlSelect->order('id desc');

        $resultSet = $this->tableGateway->selectWith($sqlSelect);
        return $resultSet;
    }

    public function fetchAll2() {
        $sqlSelect = $this->tableGateway->getSql()->select();
        $sqlSelect->columns(array('id', 'examination', 'final_decision', 'certification_issuer', 'date_certificate_issued', 'date_certificate_sent', 'certification_type'));
        $sqlSelect->join('examination', 'examination.id = certification.examination ', array('provider'), 'left')
                ->join('provider', 'provider.id = examination.provider ', array('last_name', 'first_name', 'middle_name', 'certification_id', 'certification_reg_no', 'professional_reg_no'), 'left')
                ->where(array('final_decision' => 'failed'))
                ->where(array('final_decision' => 'pending'), \Zend\Db\Sql\Where::OP_OR);
        $sqlSelect->order('id desc');

        $resultSet = $this->tableGateway->selectWith($sqlSelect);
        return $resultSet;
    }

    public function getCertification($id) {
        $id = (int) $id;
        $rowset = $this->tableGateway->select(array('id' => $id));
        $row = $rowset->current();
        if (!$row) {
            throw new \Exception("Could not find row $id");
        }
        return $row;
    }

    public function saveCertification(Certification $certification) {
                
        $data = array(
            'examination' => $certification->examination,
            'final_decision' => $certification->final_decision,
            'certification_issuer' => strtoupper($certification->certification_issuer),
            'date_certificate_issued' => $certification->date_certificate_issued,
            'date_certificate_sent' => $certification->date_certificate_sent,
            'certification_type' => $certification->certification_type,
        );

        $id = (int) $certification->id;
        if ($id == 0) {
            $this->tableGateway->insert($data);
        } else {
            if ($this->getCertification($id)) {
                $this->tableGateway->update($data, array('id' => $id));
            } else {
                throw new \Exception('certification id does not exist');
            }
        }
    }

    public function last_id() {
        $last_id = $this->tableGateway->lastInsertValue;
//        die($last_id);
        return $last_id;
    }

    public function updateExamination($last_id) {
        $db = $this->tableGateway->getAdapter();
        $sql1 = 'select examination from certification where id=' . $last_id;
        $statement = $db->query($sql1);
        $result = $statement->execute();
        foreach ($result as $res) {
            $examination = $res['examination'];
        }

//        die ($examination);

        $sql = 'UPDATE examination SET add_to_certification= "yes" WHERE id=' . $examination;

        $db->getDriver()->getConnection()->execute($sql);
    }

    public function setToActive($last_id) {
        $db = $this->tableGateway->getAdapter();
        $sql1 = 'SELECT id_written_exam,practical_exam_id,final_decision FROM certification ,examination WHERE certification.examination=examination.id and certification.id=' . $last_id;
        $statement1 = $db->query($sql1);
        $result1 = $statement1->execute();

        foreach ($result1 as $res1) {
            $written = $res1['id_written_exam'];
            $practical = $res1['practical_exam_id'];
            $decision = $res1['final_decision'];
        }
        if ((strcasecmp($decision, 'Certified') == 0) || (strcasecmp($decision, 'failed') == 0)) {
// 
            $sql2 = "UPDATE written_exam SET display='no' WHERE id_written_exam=" . $written;
            $statement2 = $db->query($sql2);
            $result2 = $statement2->execute();

            $sql3 = "UPDATE practical_exam SET display='no' WHERE practice_exam_id=" . $practical;
            $statement3 = $db->query($sql3);
            $result3 = $statement3->execute();
        }
    }

    public function certificationType($provider) {
        $db = $this->tableGateway->getAdapter();
        $sql1 = 'SELECT certification_id FROM provider WHERE id =' . $provider;
        $statement = $db->query($sql1);
        $result = $statement->execute();
        foreach ($result as $res) {
            $certification_id = $res['certification_id'];
        }

        return $certification_id;
    }

    public function certificationId($provider)
    {
        $db = $this->tableGateway->getAdapter();
        $sql = 'SELECT MAX(certification_id) as max FROM provider';
        $statement = $db->query($sql);
        $result = $statement->execute();
        foreach ($result as $res) {
            $max = $res['max'];
        }
        $array = explode("C", $max);
        $array2 = explode("-", $max);

        if (date('Y') > $array2[0]) {

            $certification_id = date('Y') . '-C' . substr_replace("0000", 1, -strlen(1));
        } else {

            $certification_id = $array2[0] . '-C' . substr_replace("0000", ($array[1] + 1), -strlen(($array[1] + 1)));
        }
        
        $sql2 = "UPDATE provider SET certification_id='".$certification_id."' WHERE id=" . $provider;
       
        $db->getDriver()->getConnection()->execute($sql2);
    }
}
